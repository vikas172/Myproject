require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { crew: @job.crew, description: @job.description, end_date: @job.end_date, end_time: @job.end_time, first_invoice_on: @job.first_invoice_on, invoice_period: @job.invoice_period, invoicing: @job.invoicing, scheduled: @job.scheduled, start_date: @job.start_date, start_time: @job.start_time, visits: @job.visits }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, id: @job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job
    assert_response :success
  end

  test "should update job" do
    patch :update, id: @job, job: { crew: @job.crew, description: @job.description, end_date: @job.end_date, end_time: @job.end_time, first_invoice_on: @job.first_invoice_on, invoice_period: @job.invoice_period, invoicing: @job.invoicing, scheduled: @job.scheduled, start_date: @job.start_date, start_time: @job.start_time, visits: @job.visits }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, id: @job
    end

    assert_redirected_to jobs_path
  end
end
