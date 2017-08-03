require 'test_helper'

class DetailThreesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detail_three = detail_threes(:one)
  end

  test "should get index" do
    get detail_threes_url
    assert_response :success
  end

  test "should get new" do
    get new_detail_three_url
    assert_response :success
  end

  test "should create detail_three" do
    assert_difference('DetailThree.count') do
      post detail_threes_url, params: { detail_three: { disburse_date: @detail_three.disburse_date, loan: @detail_three.loan, pay_strt_date: @detail_three.pay_strt_date, rate: @detail_three.rate, term: @detail_three.term } }
    end

    assert_redirected_to detail_three_url(DetailThree.last)
  end

  test "should show detail_three" do
    get detail_three_url(@detail_three)
    assert_response :success
  end

  test "should get edit" do
    get edit_detail_three_url(@detail_three)
    assert_response :success
  end

  test "should update detail_three" do
    patch detail_three_url(@detail_three), params: { detail_three: { disburse_date: @detail_three.disburse_date, loan: @detail_three.loan, pay_strt_date: @detail_three.pay_strt_date, rate: @detail_three.rate, term: @detail_three.term } }
    assert_redirected_to detail_three_url(@detail_three)
  end

  test "should destroy detail_three" do
    assert_difference('DetailThree.count', -1) do
      delete detail_three_url(@detail_three)
    end

    assert_redirected_to detail_threes_url
  end
end
