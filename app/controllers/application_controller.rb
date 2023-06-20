class ApplicationController < ActionController::API
  before_action :test
  after_action :test2
  around_action :test3

  def index
    redirect_to :show
  end

  def show
    render json: { message: 'Hello World!' }
  end

  private
  def test
    puts 'test'
  end

  def test2
    puts 'test2'
  end

  def test3
    puts 'test3'
  end
end
