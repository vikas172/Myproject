class KeyActionsController < ApplicationController
  before_action :set_key_action, only: [:show, :edit, :update, :destroy]

  # GET /key_actions
  # GET /key_actions.json
  def index
    @key_actions = KeyAction.all
  end

  # GET /key_actions/1
  # GET /key_actions/1.json
  def show
  end

  # GET /key_actions/new
  def new
    @key_action = KeyAction.new
  end

  # GET /key_actions/1/edit
  def edit
  end

  # POST /key_actions
  # POST /key_actions.json
  def create
    @key_action = KeyAction.new(key_action_params)

    respond_to do |format|
      if @key_action.save
        format.html { redirect_to @key_action, notice: 'Key action was successfully created.' }
        format.json { render action: 'show', status: :created, location: @key_action }
      else
        format.html { render action: 'new' }
        format.json { render json: @key_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /key_actions/1
  # PATCH/PUT /key_actions/1.json
  def update
    respond_to do |format|
      if @key_action.update(key_action_params)
        format.html { redirect_to @key_action, notice: 'Key action was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @key_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /key_actions/1
  # DELETE /key_actions/1.json
  def destroy
    @key_action.destroy
    respond_to do |format|
      format.html { redirect_to key_actions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key_action
      @key_action = KeyAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def key_action_params
      params.require(:key_action).permit(:key_id, :action_type_id, :sequence, :say, :play, :dial, :record, :gather, :sms)
    end
end
