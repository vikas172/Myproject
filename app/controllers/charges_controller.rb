class ChargesController < ApplicationController
  before_action :authenticate_user!
  include ChargesHelper

#Creta new charge object
  def new
    @present_coupon=CouponStripe.find_by_user_id(current_user.id)
    @subscription=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last rescue ""
    @charge = Charge.find_by_user_id(current_user.id)
    amount=plan_type(current_user)
    unless  @subscription.try(:active_date).blank?
      @base_charge = (@subscription.try(:active_date)+1.month < Date.today) ? amount : 0
    else
      @base_charge=amount
    end

    @all_payment=[]
    @charge_present=Charge.find_by_user_id(current_user.id)
    if !@charge_present.blank?
      @charges_plan= Charge.where(:user_id=> current_user.id).collect(&:account_status).reverse
      @charges_id= Charge.where(:user_id=> current_user.id).collect(&:id).reverse
      Stripe::Charge.all.data.each {|d| @all_payment << d if d["card"]["customer"]== @charge_present.customer_id}
    end
  end

#Create customer and charge 
  def create
    # Amount in cents
    if !params[:base_charge].blank?
      @amount =  (params[:base_charge].to_f*100).to_i
    else
      @amount = plan_type(current_user)
    end

    if @amount.to_i>0

      @charge=Charge.find_by_user_id(current_user.id)
      if !@charge.blank?
        @customer_id = @charge.customer_id
      end

      if @customer_id.blank?
        customer = Stripe::Customer.create(
          :email => params[:charge][:email],
          :card  => params[:stripeToken]
        )
      end

      charge = Stripe::Charge.create(
        :customer    => @customer_id.blank? ? customer.id : @customer_id,
        :amount      => @amount,
        :description => 'customer transaction',
        :currency    => 'usd'
      )
      
      @charge_info=Charge.new(charge_params)
      charge_present=Charge.find_by_user_id(current_user.id)
      if charge_present.blank?
        @charge_info.account_status = current_user.plan_type
      else
        if charge_present.active_date+ 30 < Date.today
          @charge_info.account_status = current_user.plan_type
        end    
      end   
      @charge_info.customer_id= @customer_id.blank? ? customer.id : @customer_id 
      create_charge_value(@charge_info, charge,params)
      flash[:notice] = "Your payment is successfully received!"
      redirect_to charges_new_path
    else
      flash[:notice]= "Amount is not sufficient for payment! "
      redirect_to charges_new_path
    end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_new_path
  end


#Charge method call
  def create_charge_value(charge_info, charge,params)
    charge_info.transaction_id=charge[:id]
    charge_info.amount=charge[:amount]
    charge_info.paid=charge[:paid]
    charge_info.user_id=current_user.id
    charge_info.active_date=Date.today
    charge_info.account_status= params[:type] if !params[:type].blank?
    charge_info.save
    current_user.plan_type=params[:type]
    current_user.save
  end

  def index
  end

  def referral
  end

  def referral_update
    current_user.update(:referral_code=>params[:referral_details][:referral_code])
    redirect_to request.referrer
  end

  #add ons
  def add_on
    @user_add_on = current_user.add_on_statuses
    @add_on = AddOnStatus.new
  end

  def addon_active
    @add_on_present = AddOnStatus.find_by_user_id_and_add_on(current_user.id, params[:value])
    unless @add_on_present.present?
      @add_on = AddOnStatus.create(status: params[:status], charge: params[:price], user_id: current_user.id, add_on: params[:value])
    else
      @add_on_present.status = params[:status]
      @add_on_present.save
    end
  end

#Coupan generate code
  def coupan_create
    
    present_coupon=CouponStripe.find_by_user_id(current_user.id)
    charge_present=Charge.where("user_id =? AND account_status= ?",current_user.id,current_user.plan_type).last

    if !charge_present.blank?
      coupan_view=Stripe::Coupon.retrieve(params[:coupan_id]) rescue false
      if coupan_view == false
        redirect_to charges_new_path ,:notice=>"Your Coupan ID is incorrect please try again"
      else
        if present_coupon.blank? 
          discount_amount=discount_coupon(current_user,coupan_view)
          transaction = Stripe::Charge.retrieve(charge_present.transaction_id)
          sucess_refund=transaction.refunds.create(:amount=>(discount_amount*100).to_i) rescue false
          if sucess_refund
            @coupon=CouponStripe.create(:coupon_id=>coupan_view.id,:coupon_release=>Time.at(coupan_view.created),:percent_off=>coupan_view.percent_off,:currency=>coupan_view.currency,:duration=>coupan_view.duration,:times_redeemed=>coupan_view.times_redeemed,:coupon_valid=>coupan_view.valid,:user_id=>current_user.id)
          else
            redirect_to charges_new_path ,:notice=>"Something went wrong on this coupon id"
          end
          redirect_to charges_new_path ,:notice=>"You Coupon Successfully Accecepted And Release discount Amount Successfully"
        elsif present_coupon.duration =="once"
          redirect_to charges_new_path ,:notice=>"You have used this coupon already or expired"
        elsif  present_coupon.duration == "repeating"

          plan_amount=plan_type(current_user)
         
          if charge_present.active_date+30 < Date.today
            coupan_view=Stripe::Coupon.retrieve(params[:coupan_id]) rescue false
            if coupon_view == false
              redirect_to charges_new_path ,:notice=>"Your Coupan ID is incorrect please try again"
            else
              discount_amount=discount_coupon(current_user,coupan_view)
              transaction = Stripe::Charge.retrieve(charge_present.transaction_id)
              sucess_refund=transaction.refunds.create(:amount=>(discount_amount*100).to_i) rescue false
              if sucess_refund
                @coupon=present_coupon.update(:coupon_id=>coupan_view.id,:coupon_release=>Time.at(coupan_view.created),:percent_off=>coupan_view.percent_off,:currency=>coupan_view.currency,:duration=>coupan_view.duration,:times_redeemed=>coupan_view.times_redeemed,:coupon_valid=>coupan_view.valid,:user_id=>current_user.id)
              else
                redirect_to charges_new_path ,:notice=>"Something went wron on this coupon id"
              end
            end
          else
            redirect_to charges_new_path ,:notice=>"You have already used this coupon in the month"
          end  
        end  
      end
    else
      redirect_to charges_new_path ,:notice=>"You are not done your plan payment yet"
    end 
  end

#Charge receipt view
  def view_receipt
    @payment= Stripe::Charge.retrieve(params[:id])
    @account_type=Charge.find(params[:data]).account_status
  end

# Charge receipt pdf
  def receipt_pdf
    @payment= Stripe::Charge.retrieve(params[:id])
    html = render_to_string(:layout => false )
    @charges_plan= Charge.where(:user_id=> current_user.id).collect(&:account_status).reverse
    kit = PDFKit.new(html, :page_size => 'Letter')
    send_data(kit.to_pdf, :filename => "receipt_pdf", :type => 'application/pdf')
  end

  def payment_terminal
  end
  
#Payement terminal section
  def payment_terminal_set
    customer = Stripe::Customer.create(
      :email => params[:payment_terminal][:email],
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id ,
      :amount      => (params[:payment_terminal][:amount].to_f*100).to_i,
      :description => 'payment-terminal transaction',
      :currency    => 'usd'
    )

    if charge.id.present?
      params[:payment_terminal][:customer_id] = customer.id
      params[:payment_terminal][:transaction_id] = charge.id

      payment_terminal = PaymentTerminal.create(params[:payment_terminal].permit!)

      flash[:notice] = "Payment successfully done!"
      redirect_to :back

    end

    rescue Stripe::CardError => e
      flash[:notice] = e.message
      redirect_to :back
  end

  private

    def charge_params
      params.require(:charge).permit(:name, :email,:card_number, :exp_month, :exp_year,:cvc,:address1,:address2,:city,:state ,:country, :zip_code)
    end

    def add_on_params
      params.require(:add_on).permit(:status, :paid, :charge, :user_id, :add_on)
    end
end
