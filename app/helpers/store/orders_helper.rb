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
      "待結帳"
    when "paid"
      "已付款"
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

  def check_stock(item)
    quantity = item.quantity
    stock = item.product.stock
    if quantity > stock 
      content_tag(:span, "不足", style: "color: red")
    else
      content_tag(:span, "有")
    end
  end
end
