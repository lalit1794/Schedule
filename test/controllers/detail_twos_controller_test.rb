require 'test_helper'

class DetailTwosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detail_two = detail_twos(:one)
  end

  test "should get index" do
    get detail_twos_url
    assert_response :success
  end

  test "should get new" do
    get new_detail_two_url
    assert_response :success
  end

  test "should create detail_two" do
    assert_difference('DetailTwo.count') do
      post detail_twos_url, params: { detail_two: { disburse_date: @detail_two.disburse_date, loan: @detail_two.loan, pay_strt_date: @detail_two.pay_strt_date, rate: @detail_two.rate, term: @detail_two.term } }
    end

    assert_redirected_to detail_two_url(DetailTwo.last)
  end

  test "should show detail_two" do
    get detail_two_url(@detail_two)
    assert_response :success
  end

  test "should get edit" do
    get edit_detail_two_url(@detail_two)
    assert_response :success
  end

  test "should update detail_two" do
    patch detail_two_url(@detail_two), params: { detail_two: { disburse_date: @detail_two.disburse_date, loan: @detail_two.loan, pay_strt_date: @detail_two.pay_strt_date, rate: @detail_two.rate, term: @detail_two.term } }
    assert_redirected_to detail_two_url(@detail_two)
  end

  test "should destroy detail_two" do
    assert_difference('DetailTwo.count', -1) do
      delete detail_two_url(@detail_two)
    end

    assert_redirected_to detail_twos_url
  end
end
