class NumbersController < ApplicationController
  before_action :set_number, only: [:show, :edit, :update, :destroy]

  def update_ivr_number
    
    @number = Number.find(number_params[:id])
    @ivr = Ivr.find( number_params[:ivr_id])
    Number.where(:ivr_id => @ivr.id ).update_all(:ivr_id => nil)
    @number.update(:ivr_id => @ivr.id)
    respond_to do |format|
      format.html { redirect_to edit_ivr_path(@ivr.uuid), notice: "Number #{@number.phone_number} successfully assigned to your account" }
    end
  end


  def search
    @numbers = Number.all
    @client = Twilio::REST::Client.new $account_sid, $auth_token
    numbers = @client.account.available_phone_numbers.get("US").local.list(:contains => params[:number][:prefix] + "*"*(10 - params[:number][:prefix].size), :voice_enabled => "true")
    if numbers and numbers.count > 1
      purchasing_number = numbers.first.phone_number
      logger.debug "Attempting to purchase #{purchasing_number}"
      #purchase
      @client.account.incoming_phone_numbers.create(:phone_number => purchasing_number,
                                                    :voice_url => "http://45.55.157.4/ivrs/42827ca66fd341bdbc180b4f6e7f1b74/twiml",
                                                    :voice_method => "GET"

      )
       #local repo
      Number.create(:account_sid => $account_sid,
                           :auth_token => $auth_token,
                           :voice => "http://45.55.157.4/ivrs/42827ca66fd341bdbc180b4f6e7f1b74/twiml",
                           :phone_number => purchasing_number
                           #:phone_sid => @client.account.incoming_phone_numbers.last.
      )
      @notice = {:message => "Purchased the number #{purchasing_number} and added to your repository" , :status => "success"}
    else
      @notice = {:message => "No numbers available with the prefix requested" ,:status => "failure"}
    end
    render "numbers/index"
  end

  # GET /numbers
  # GET /numbers.json
  def index
    @ivr = Ivr.where(:uuid => "42827ca66fd341bdbc180b4f6e7f1b74").first
    @numbers = Number.all
  end

  # GET /numbers/1
  # GET /numbers/1.json
  def show
  end

  # GET /numbers/new
  def new
    @number = Number.new(:account_sid =>$account_sid,
                         :auth_token => $auth_token ,
                         #:voice => twiml_ivr_url(:id => Ivr.first.uuid),
                         :voice => "http://45.55.157.4/ivrs/42827ca66fd341bdbc180b4f6e7f1b74/twiml"
    )
  end

  # GET /numbers/1/edit
  def edit
  end

  # POST /numbers
  # POST /numbers.json
  def create
    @number = Number.new(number_params)
    @number.user_id = current_user.id
    respond_to do |format|
      
      if @number.save
        @number.configure_in_twilio
        format.html { redirect_to numbers_path, notice: 'Number was successfully created.' }
        format.json { render action: 'show', status: :created, location: @number }
      else
        format.html { render action: 'new' }
        format.json { render json: @number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /numbers/1
  # PATCH/PUT /numbers/1.json
  def update
    respond_to do |format|
      if @number.update(number_params)
        @number.configure_in_twilio
        format.html { redirect_to numbers_path, notice: 'Number was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /numbers/1
  # DELETE /numbers/1.json
  def destroy
    @client = Twilio::REST::Client.new $account_sid, $auth_token
    deleted = 0
    @client.account.incoming_phone_numbers.list({:phone_number => @number.phone_number}).each do |n|
      n.delete
      deleted = 1
    end
    @number.destroy if deleted == 1
    respond_to do |format|
      format.html { redirect_to numbers_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_number
    @number = Number.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def number_params
    params.require(:number).permit(:account_sid, :auth_token, :phone_number, :phone_sid, :user_id, :voice, :sms, :ivr_id, :id)
  end
end
