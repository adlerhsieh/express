module Store::OrdersHelper
  def order_title
    if @order.aasm_state == "cart"
      content_tag(:h2, "購物車明細")
    else
      content_tag(:h2, "訂單明細")
    end
  end

  def status_print(state)
    case state
    when "cart"
      "尚未下單"
    when "placed"
      "待付款"
    when "transferred"
      "待確認轉帳資訊"
    when "paid"
      "已付款"
    when "shipped"
      "已出貨"
    when "arrived"
      "已到貨"
    when "cancelled"
      "已作廢"
    when "returned"
      "已退回"
    when "outdated"
      "已過期"
    end
  end

  def highlight_pending(order)
    case order.aasm_state
    when "transferred","paid","shipped"
      "pending"
    else
      ""
    end
  end

  def progress
    result = String.new
    if @order.order_time
      result += 
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已下單") + 
        content_tag(:span, (@order.order_time + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") +
        content_tag(:p, "")
    end
    # if @order.transfer.
    if @order.pay_time
      result += 
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已付款") + 
        content_tag(:span, (@order.pay_time + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") + 
        content_tag(:p, "")
    end
    if @order.shipping_time
      result +=
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已出貨") + 
        content_tag(:span, (@order.shipping_time + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") +
        content_tag(:p, "")
    end
    if @order.arrived_at
      result +=
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已到貨") + 
        content_tag(:span, (@order.arrived_at + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") + 
        content_tag(:p, "")
    end
    if @order.returned_at
      result +=
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已退回") + 
        content_tag(:span, (@order.returned_at + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") + 
        content_tag(:p, "")
    end
    if @order.cancelled_at
      result +=
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: red; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已作廢") + 
        content_tag(:span, (@order.cancelled_at + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") + 
        content_tag(:p, "")
    end
    return nil if not result
    result.html_safe
  end

  def next_step
    case
    when @order.paid?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：等待出貨通知", style: "font-size: 14px;")
    when @order.arrived?
       result = ""
    when @order.shipping_time
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：等待到貨", style: "font-size: 14px;")
    when !@order.has_info
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：填寫完整寄送資訊", style: "font-size: 14px;")
    when @order.transferred?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：等待轉帳確認", style: "font-size: 14px;")
    when @order.placed?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：付款", style: "font-size: 14px;")
    when @order.cart?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：結帳", style: "font-size: 14px;")
    else
      return
    end
    result.html_safe
  end

  def action_button
    if @order.cart?
      return link_to "結帳", place_store_order_path(@order), class: "btn btn-primary checkout" 
    end
    @button_class = {class: "btn btn-primary paypal-send", method: :get}
    @button_class.merge!(disabled: "disabled") if not @order.has_info && @order.stock_ready
    if @order.paid?
      return content_tag(:p, "即將出貨，請耐心等候！", style: "float: right; margin-top: 20px;")
    end
    if @order.shipped?
      return content_tag(:p, "已出貨，請耐心等候！", style: "float: right; margin-top: 20px;")
    end
    if @order.arrived?
      return content_tag(:p, "已到貨", style: "float: right; margin-top: 20px;")
    end
    if @order.returned?
      return content_tag(:p, "已退貨", style: "float: right; margin-top: 20px;")
    end
    # if @order.placed? || @order.transferred?
    if @order.placed?
      if @order.info
        render partial: "pay_form"
      else
        render partial: "shipping_new"
      end
    end
  end

  def check_stock(item)
    quantity = item.quantity
    stock = item.product.stock
    if quantity > stock 
      @out_of_stock = true
      content_tag(:span, "不足", style: "color: red")
    else
      content_tag(:span, "有")
    end
  end

  def warning
    result = []
    if @order.cart?
      result << content_tag(:span, "下單後即代表您已詳細閱讀及同意", style: "color: black") + 
        link_to("服務說明及使用規範", terms_of_service_path, target: "_blank")
    end
    if @order.placed?
      result << content_tag(:span, "庫存不足，請將不足的品項移除或更新數量才可結帳") if @out_of_stock
      result << content_tag(:span, "請完整填寫寄送資訊") unless @order.has_info || !@order.info
    end
    return result.join(content_tag(:p, "")).html_safe
  end

  def total_quantity
    @order.items.inject(0){|r,i| r += i.quantity }
  end

  def total_price
    @order.price
    # @order.items.inject(0){|r,i| r += i.sum }
  end

  def date(time)
    if time
      time.strftime("%Y-%m-%d")
    else
      "--"
    end
  end

  def time(time)
    if time
      time.strftime("%H:%M:%S")
    end
  end

  def shipping_class
    if @order.info.nil?
      "btn-primary"
    else
      "btn-warning"
    end
  end

  def transfer_info
    text = @transfer.confirm ? "已確認" : "已填，尚未確認"
    content_tag(:p, text)
  end

  def shipping_info
    case
    when @order.paid?
      content_tag(:p, "待出貨")
    when @order.shipped?
      content_tag(:p, "已出貨")
    when @order.arrived?, @order.returned?
      content_tag(:p, "已送達")
    end
  end

  def returned_info
    case
    when @order.arrived?
      content_tag(:p, "--")
    when @order.returned?
      content_tag(:p, "已退回")
    end
  end

  def paypal_info
    case @notifier.status
    when "Completed"
      "已完成"
    when "Pending"
      "需至PayPal確認，txn_id: #{@notifier.transaction_id}"
    when "Cancelled"
      "已交易但取消"
    end
  end

end
