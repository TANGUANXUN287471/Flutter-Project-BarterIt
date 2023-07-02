class Cart {
  String? cartId;
  String? itemId;
  String? itemName;
  String? itemCondition;
  String? itemType;
  String? itemDesc;
  String? itemQty;
  String? cartPrice;
  String? cartQty;
  String? userId;
  String? sellerId;
  String? cartDate;

  Cart(
      {this.cartId,
      this.itemId,
      this.itemName,
      this.itemCondition,
      this.itemType,
      this.itemDesc,
      this.itemQty,
      this.cartPrice,
      this.cartQty,
      this.userId,
      this.sellerId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemCondition = json['item_condition'];
    itemType = json['item_type'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    cartPrice = json['cart_price'];
    cartQty = json['cart_qty'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_condition'] = itemCondition;
    data['item_type'] = itemType;
    data['item_desc'] = itemDesc;
    data['item_qty'] = itemQty;
    data['cart_price'] = cartPrice;
    data['cart_qty'] = cartQty;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['cart_date'] = cartDate;
    return data;
  }
}