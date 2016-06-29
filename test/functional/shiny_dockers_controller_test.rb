require 'test_helper'

class ShinyDockersControllerTest < ActionController::TestCase
  setup do
    @shiny_docker = shiny_dockers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shiny_dockers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shiny_docker" do
    assert_difference('ShinyDocker.count') do
      post :create, shiny_docker: { appdesc: @shiny_docker.appdesc, appname: @shiny_docker.appname, expired: @shiny_docker.expired, host: @shiny_docker.host, netid: @shiny_docker.netid, port: @shiny_docker.port, pw: @shiny_docker.pw }
    end

    assert_redirected_to shiny_docker_path(assigns(:shiny_docker))
  end

  test "should show shiny_docker" do
    get :show, id: @shiny_docker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shiny_docker
    assert_response :success
  end

  test "should update shiny_docker" do
    put :update, id: @shiny_docker, shiny_docker: { appdesc: @shiny_docker.appdesc, appname: @shiny_docker.appname, expired: @shiny_docker.expired, host: @shiny_docker.host, netid: @shiny_docker.netid, port: @shiny_docker.port, pw: @shiny_docker.pw }
    assert_redirected_to shiny_docker_path(assigns(:shiny_docker))
  end

  test "should destroy shiny_docker" do
    assert_difference('ShinyDocker.count', -1) do
      delete :destroy, id: @shiny_docker
    end

    assert_redirected_to shiny_dockers_path
  end
end
