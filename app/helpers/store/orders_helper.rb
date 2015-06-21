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
      "購物車"
    when "placed"
      "已下單，待結帳"
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
        content_tag(:span, @order.order_time.strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp") +
        content_tag(:p, "")
    end
    if @order.pay_time
      result += 
        content_tag(:i, "", class: "fa fa-check-circle", style: "color: green; font-size: 20px; padding-right: 5px;") + 
        content_tag(:span, "已付款") + 
        content_tag(:span, @order.pay_time.strftime("%Y-%m-%d %H:%M:%S"), class: "timestamp")
    end
    result.html_safe
  end

  def next_step
    case
    when @order.paid?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：等待出貨通知", style: "font-size: 14px;")
    when @order.placed?
      result = 
        content_tag(:i, "", class: "fa fa-arrow-circle-right", style: "color: gray; font-size: 16px; padding-right: 5px;") + 
        content_tag(:span, "下一步：前往付款", style: "font-size: 14px;")
    end
    result.html_safe
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

  def stock_warning
    content_tag(:span, "庫存不足，請將不足的品項移除才可結帳", :class => "warning") if @out_of_stock
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
