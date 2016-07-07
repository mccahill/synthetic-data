require 'test_helper'

class RemoteJobsControllerTest < ActionController::TestCase
  setup do
    @remote_job = remote_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:remote_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create remote_job" do
    assert_difference('RemoteJob.count') do
      post :create, remote_job: { completeted: @remote_job.completeted, epsilon: @remote_job.epsilon, model: @remote_job.model, netid: @remote_job.netid, output_unit: @remote_job.output_unit, submitted: @remote_job.submitted }
    end

    assert_redirected_to remote_job_path(assigns(:remote_job))
  end

  test "should show remote_job" do
    get :show, id: @remote_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @remote_job
    assert_response :success
  end

  test "should update remote_job" do
    put :update, id: @remote_job, remote_job: { completeted: @remote_job.completeted, epsilon: @remote_job.epsilon, model: @remote_job.model, netid: @remote_job.netid, output_unit: @remote_job.output_unit, submitted: @remote_job.submitted }
    assert_redirected_to remote_job_path(assigns(:remote_job))
  end

  test "should destroy remote_job" do
    assert_difference('RemoteJob.count', -1) do
      delete :destroy, id: @remote_job
    end

    assert_redirected_to remote_jobs_path
  end
end
