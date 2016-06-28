class ActionTypesController < ApplicationController
  # GET /key_actions
  # GET /key_actions.json
  # Display all the Listing actions
  def index
    @action_types = ActionType.all
  end
end