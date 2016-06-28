class ExpensesController < ApplicationController
	before_action :authenticate_user!

#Display the list of expenses
	def index
		unless params[:filters].blank?
			if params[:filters][:type] == "all" && params[:filters][:entered_by].blank?
				@expenses = current_user.expenses		
			elsif params[:filters][:type] == "pending_payment" && params[:filters][:entered_by].blank?
				@expenses = current_user.expenses.where(pending_payment: true)
			elsif params[:filters][:type] == "pending_payment" && !params[:filters][:entered_by].blank?
				@expenses = current_user.expenses.where(pending_payment: true, user_id: params[:filters][:entered_by])
			else
				@expenses = current_user.expenses.where(user_id: params[:filters][:entered_by])
			end
		else
			@expenses = current_user.expenses
		end
		@cost = @expenses.pluck(:cost).sum 
	end

# Object create on the expense modal
	def new
		@expense = Expense.new
		@category= CustomCategory.where(:category_type=>"expenses",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"expenses",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@custom_expense = current_user.custom_expense
		@jobs = Job.where(user_id: current_user.id)
	end

#Expense created
	def create
		@expense = Expense.create(expense_params)
		if params[:distance].blank?
			@expense.expense_type="merchant"
		else
			@expense.expense_type=params[:distance]
		end
		@expense.save
		UserMailer.expense_notification(current_user,@expense).deliver
		redirect_to expenses_path
	end

#Expense edit view
	def edit
		@category= CustomCategory.where(:category_type=>"expenses",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"expenses",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@expense = Expense.find(params[:id])
		@jobs = Job.where(user_id: current_user.id)
	end

#Expense update
	def update
		@expense = Expense.find(params[:id])
		@expense.update(expense_params)
		redirect_to expenses_path
	end

#expense destory
	def destroy
		@expense = Expense.find(params[:id])
		@expense.destroy
		redirect_to expenses_path
	end

#display mile category if present
	def mile_category
    @custom_expense =  current_user.custom_expense
		@categories = CustomCategory.where(:user_id=>current_user.id.to_s,:category_type=>"expenses")
	end

#Create mileage expense on custom expense object
	def create_mileage
    if current_user.custom_expense.blank?
			@custom= CustomExpense.new(custom_params)
			@custom.save
		else
			@custom = current_user.custom_expense
			@custom.update(custom_params)
		end
		redirect_to expenses_mileage_expenses_path
	end

#Create custom category object
	def category_create
		@category = CustomCategory.new(category_params)
		@category.save
		if request.referrer.include? "category_new"
			@categories = CustomCategory.where(:user_id=>current_user.id.to_s,:category_type=>"timesheets")
		else
			@categories = CustomCategory.where(:user_id=>current_user.id.to_s,:category_type=>"expenses")
		end
	end

#edit custom category object
	def category_edit
		@category = CustomCategory.find(params[:id])
	end

#update custom category object
	def category_update
		@category = CustomCategory.find(params[:id])
		@category.update(category_params)
		redirect_to expenses_mileage_expenses_path
	end

#Custom category delete
	def category_delete
		@category = CustomCategory.find(params[:id])
		@category.destroy
		redirect_to expenses_mileage_expenses_path
	end

	private
		def expense_params
			params.require(:expense).permit(:miles,:exp_billable,:exp_reimbursable,:unit,:clean_date,:exp_category, :name, :note, :cost, :reimbursable_to_id, :job_id, :user_id, :image)
		end
		def category_params
			params.require(:custom).permit(:user_id,:category,:category_type)
		end
		def custom_params
			params.require(:custom_expense).permit(:user_id,:km,:mileage,:default_unit)
		end
end