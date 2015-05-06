class Users::TrainingsController < ApplicationController
  def index
    @trainings = Training.all
  end

  def new
  end

  def edit
  end

  def show
  end
end
