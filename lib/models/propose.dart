class Propose {
  String? proposeId;
  String? proposeStatus;
  String? sellerItemId;
  String? sellerItemName;
  String? sellerItemQty;
  String? sellerItemValue;
  String? sellerItemDesc;
  String? itemName;
  String? itemType;
  String? itemCondition;
  String? itemDesc;
  String? itemValue;
  String? itemQty;
  String? proposeItemId;
  String? proposeItemName;
  String? proposeItemQty;
  String? proposeItemValue;
  String? proposeItemDesc;
  String? buyerId;
  String? sellerId;

  Propose(
      {this.proposeId,
      this.proposeStatus,
      this.sellerItemId,
      this.sellerItemName,
      this.sellerItemQty,
      this.sellerItemValue,
      this.sellerItemDesc,
      this.itemName,
      this.itemType,
      this.itemCondition,
      this.itemDesc,
      this.itemValue,
      this.itemQty,
      this.proposeItemId,
      this.proposeItemName,
      this.proposeItemQty,
      this.proposeItemValue,
      this.proposeItemDesc,
      this.buyerId,
      this.sellerId});

  Propose.fromJson(Map<String, dynamic> json) {
    proposeId = json['propose_id'];
    proposeStatus = json['propose_status'];
    sellerItemId = json['seller_item_id'];
    sellerItemName = json['seller_item_name'];
    sellerItemQty = json['seller_item_qty'];
    sellerItemValue = json['seller_item_value'];
    sellerItemDesc = json['seller_item_desc'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemCondition = json['item_condition'];
    itemDesc = json['item_desc'];
    itemValue = json['item_value'];
    itemQty = json['item_qty'];
    proposeItemId = json['propose_item_id'];
    proposeItemName = json['propose_item_name'];
    proposeItemQty = json['propose_item_qty'];
    proposeItemValue = json['propose_item_value'];
    proposeItemDesc = json['propose_item_desc'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propose_id'] = proposeId;
    data['propose_status'] = proposeStatus;
    data['seller_item_id'] = sellerItemId;
    data['seller_item_name'] = sellerItemName;
    data['seller_item_qty'] = sellerItemQty;
    data['seller_item_value'] = sellerItemValue;
    data['seller_item_desc'] = sellerItemDesc;
    data['item_name'] = itemName;
    data['item_type'] = itemType;
    data['item_condition'] = itemCondition;
    data['item_desc'] = itemDesc;
    data['item_value'] = itemValue;
    data['item_qty'] = itemQty;
    data['propose_item_id'] = proposeItemId;
    data['propose_item_name'] = proposeItemName;
    data['propose_item_qty'] = proposeItemQty;
    data['propose_item_value'] = proposeItemValue;
    data['propose_item_desc'] = proposeItemDesc;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    return data;
  }
}