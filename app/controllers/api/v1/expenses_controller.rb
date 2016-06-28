class Api::V1::ExpensesController < Api::V1::ApiController
	skip_before_filter  :verify_authenticity_token

	def index
		if !current_user.blank?
			if current_user.user_type=="user"
				user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
				expenses = Expense.where(:user_id=>user_type_id)
			else
			  expenses=current_user.expenses
			end
			render :status=>200, :json=>expenses.as_json
		else
			render  :json=>{:status => "Failure Please login" }
		end
	end

	def new
		@category= CustomCategory.where(:category_type=>"expenses",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"expenses",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		render :status=>200, :json=>@categories.as_json
	end

	def create
		if current_user
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					expense = Expense.new(expense_params)
					expense.user_id = user_type_id
				else
					expense = Expense.new(expense_params)
					expense.user_id = current_user.id
				end
				if params[:distance].blank?
					expense.expense_type = "merchant"
				else
					expense.expense_type = params[:distance]
				end
				if expense.save
					render :status=>200, :json=>expense.as_json
				else
					render  :json=>{:status => "something went wrong please try again" }	
				end	
			else
				render :json=>{:status => "Failure match not found"}
			end
		else
			render :json=>{:status => "Failure Please login"}
		end		
	end

	def edit
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					expense = Expense.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					expense = Expense.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if expense
					render :status=>200, :json=>expense.as_json
				else
					render :status=>200, :json=>{:status => "Expense not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def update_expense
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					expense = Expense.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					expense = Expense.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end

				if expense.update(expense_params)
					if params[:distance].blank?
						expense.expense_type = "merchant"
					else
						expense.expense_type = params[:distance]
					end
					expense.save
					render :status=>200, :json=>expense.as_json
				else
					render :status=>200, :json=>{:status => "Expense failure occur "}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	def show
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					expense = Expense.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					expense = Expense.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if expense
					render :status=>200, :json=>expense.as_json
				else
					render :status=>200, :json=>{:status => "Expense not found"}
				end
			else
				render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end


	def destroy
		if !current_user.blank?
			if current_user.id == params[:user_id].to_i
				if current_user.user_type=="user"
					user_type_id=TeamMember.find_by_member_id(current_user.id).user_id
					expense = Expense.where(:user_id=>user_type_id,:id=>params[:id]).first
				else
					expense = Expense.where(:user_id=>current_user.id ,:id=>params[:id]).first
				end
				if expense
					expense.destroy
					render :status=>200, :json=>{:status => "Expense Deleted sucessfully"}
				else
					render :status=>200, :json=>{:status => "Expense not found"}
				end
			else
			  render :json=>{:status => "Failure match not found"}
			end	
		else
			render :json=>{:status => "Failure Please login"}
		end
	end

	private
	def current_user
  	User.find(params[:user_id]) rescue ""
  end

  def expense_params
			params.require(:expense).permit(:miles,:exp_billable,:exp_reimbursable,:unit,:clean_date,:exp_category, :name, :note, :cost, :reimbursable_to_id, :job_id, :user_id, :image,:distance,:expense_image,:expense_type)
  end

end