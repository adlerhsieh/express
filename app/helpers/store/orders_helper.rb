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

  def progress_bar
    return if @order.aasm_state == "cart"
    value = case @order.aasm_state
    when "placed"
      "10"
    when "paid"
      "50"
    when "delivered"
      "100"
    else
      "0"
    end
    content_tag(:progress, "", :max => "100", :value => value)
  end

  def progress_bar_status
    return if @order.aasm_state == "cart"
    content_tag(:div,
               content_tag(:span, "下單", id: "place") + 
               content_tag(:span, "付款", id: "pay") + 
               content_tag(:span, "出貨", id: "deliver"),
               :class => "status-bar")
  end

  def progress_bar_timestamp
    return if @order.aasm_state == "cart"
    content_tag(:div,
               content_tag(:span, time(@order.order_time), id: "place") + 
               content_tag(:span, time(@order.pay_time), id: "pay") + 
               content_tag(:span, time(@order.shipping_time), id: "deliver"),
               :class => "status-bar")
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

  def action_button
    @disabled = "disabled" if @out_of_stock
    _class = "btn btn-primary action #{@disabled}"
    case @order.aasm_state
    when "cart"
      link_to("確認下單", place_store_order_path(@order), class: _class)
    when "placed"
      link_to("前往付款", "", class: _class)
    else
      ""
    end
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
