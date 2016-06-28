class TimesheetsController < ApplicationController
before_action :authenticate_user!
include TimesheetsHelper

#Display list of the timesheet
	def index
		@jobs = Job.where(user_id: current_user.id)
		@timesheet = current_user.timesheets.where(:day=>Date.today)
		calculate_hours(@timesheet)
		@add_row = Timesheet.new
		@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
	end

#generate timesheet object
	def create
		@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@jobs = Job.where(user_id: current_user.id)
		@timesheet = Timesheet.create(timesheet_params)
		@timesheet.duration=params[:duration]
		if !@categories.blank?
			@timesheet.custom_category_id = @categories.first.id if params[:custom_category_id].blank?
    end
		@timesheet.save
		@timesheets = current_user.timesheets.where(:day=>@timesheet.day)
		calculate_hours(@timesheets)
	end

#calculate timesheet hours
	def calculate_hours(timesheet)
		total_hour=[]
		total_minutes=[]
		timesheet.collect(&:duration).each do |dur|
		  total_hour << dur.strftime("%H").to_i rescue 0
		  total_minutes << dur.strftime("%M").to_i rescue 0
		end
		@total=get_minutes_hours(total_minutes.sum,total_hour.sum) rescue "0:0"
	  @total_hours = @total rescue "0:0"
	end

#timesheet update
	def update
		@timesheet = Timesheet.find(params[:id])
		@timesheet.update(timesheet_params)
		@timesheet.duration=params[:duration]
		@timesheet.save
		redirect_to @timesheet
	end

#timesheet show
	def show
		@timesheet = Timesheet.find(params[:id])
		@timesheets = current_user.timesheets.where(:day=>@timesheet.day)
		calculate_hours(@timesheets)
		@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@jobs = Job.where(user_id: current_user.id)
	end

# timesheet edit 
	def edit
		@timesheet = Timesheet.find(params[:id])
		@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@jobs = Job.where(user_id: current_user.id)
	end

# timesheet destory 
	def destroy
		@timesheet = Timesheet.find(params[:id])
    @timesheet.destroy
    redirect_to timesheets_path
	end
	def category_edit
		@category = CustomCategory.find(params[:id])
	end

#update custom category object
	def category_update
		@category = CustomCategory.find(params[:id])
		@category.update(category_params)
		redirect_to category_new_timesheets_path
	end

#Custom category delete
	def category_delete
		@category = CustomCategory.find(params[:id])
		@category.destroy
		redirect_to category_new_timesheets_path
	end
#timesheet pervious day enteries display and create
  def prev_day
  	@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@jobs = Job.where(user_id: current_user.id)
  	@timesheet=current_user.timesheets.where(:day=>params[:day])
  	calculate_hours(@timesheet)
  	@add_row = Timesheet.new
  end

#timesheet next day enteries display and create
  def next_day
  	@category= CustomCategory.where(:category_type=>"timesheets",:user_id=>current_user.id.to_s)
		@cat_default= CustomCategory.where(:category_type=>"timesheets",:user_id=>nil)
		@cat_default << @category
		@categories = @cat_default.flatten
		@jobs = Job.where(user_id: current_user.id)
  	@timesheet=current_user.timesheets.where(:day=>params[:day])
  	calculate_hours(@timesheet)
  	@add_row = Timesheet.new
  end

#custom category new object initial
  def category_new
  	 @categories = CustomCategory.where(:user_id=>current_user.id.to_s,:category_type=>"timesheets")
  end

#Payroll list display
  def payroll
  	@team_members= current_user.team_members
  	@users=[]
  	@team_members.each do |team|
  		@users << User.find(team.member_id)
  	end
  end

#payroll pervious 
  def prev_payroll
  	@team_members= current_user.team_members
  	@users=[]
  	@team_members.each do |team|
  		@users << User.find(team.member_id)
  	end
  end

#payroll next
  def next_payroll
  	@team_members= current_user.team_members
  	@users=[]
  	@team_members.each do |team|
  		@users << User.find(team.member_id)
  	end
  end
	
	private
		def timesheet_params
			params.require(:timesheet).permit(:user_id,:start_date,:auto_start_timer,:job_id,:label,:note,:start_time, :end_time, :duration,:day,:custom_category_id,:billable)
		end
		def category_params
			params.require(:custom).permit(:user_id,:category,:category_type)
		end
end
