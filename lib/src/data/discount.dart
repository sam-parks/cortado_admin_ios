enum DiscountType { redemption, ordering }

extension DiscountTypeExtension on DiscountType {
  String get value {
    switch (this) {
      case DiscountType.ordering:
        return "ordering";
      case DiscountType.redemption:
        return "redemption";
      default:
        return "ordering";
    }
  }
}

DiscountType stringToDiscountTypeEnum(String type) {
  switch (type) {
    case "ordering":
      return DiscountType.ordering;
      break;
    case "redemption":
      return DiscountType.redemption;
      break;
    default:
      return DiscountType.ordering;
  }
}

class Discount {
  final String id;
  final DiscountType discountType;
  final bool active;
  final String description;
  final String title;
  final String value;

  const Discount(this.id, this.discountType, this.active, this.description,
      this.title, this.value);

  static const empty =
      const Discount('', DiscountType.ordering, false, '', '', '0.00');

  Discount.fromJson(Map<dynamic, dynamic> data)
      : this.id = data['id'],
        this.discountType = stringToDiscountTypeEnum(data['discountType']),
        this.active = data['active'],
        this.description = data['description'],
        this.value = data['value'],
        this.title = data['title'];
}
