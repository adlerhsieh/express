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
      "尚未結帳"
    when "placed"
      "已結帳，待付款"
    when "paid"
      "已付款，待出貨"
    when "shipped"
      "已出貨"
    when "arrived"
      "已到貨"
    when "cancelled"
      "已取消"
    when "returned"
      "已退回"
    when "outdated"
      "已過期"
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
        content_tag(:span, (@order.pay_time + 28800).strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp")
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
    end
    result.html_safe
  end

  def action_button
    if @order.cart?
      return link_to "結帳", place_store_order_path(@order), class: "btn btn-primary", style: "float: right; width: 100px; margin-top: 20px;"
    end
    @button_class = {class: "btn btn-primary", style: "float: right; width: 150px; margin-top: 20px; margin-left: 20px;", method: :get}
    @button_class.merge!(disabled: "disabled") if not @order.has_info && @order.stock_ready
    if @order.placed?
      render partial: "pay_form"
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
    if @out_of_stock
      result << content_tag(:span, "庫存不足，請將不足的品項移除或更新數量才可結帳")
    end
    if @order.placed?
      result << content_tag(:span, "請完整填寫寄送資訊") unless @order.has_info
    end
    return result.join(content_tag(:p, "")).html_safe
  end

  def total_quantity
    @order.items.inject(0){|r,i| r += i.quantity }
  end

  def total_price
    @order.items.inject(0){|r,i| r += i.sum }
  end

  def time(time)
    if time
      time.strftime("%Y-%m-%d %H:%M:%S")
    else
      "--"
    end
  end
end
