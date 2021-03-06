abstract class BaristaManagementEvent {}

class CreateBarista extends BaristaManagementEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final String coffeeShopId;

  CreateBarista(this.email, this.firstName, this.lastName, this.phone, this.password,
      this.coffeeShopId);
}

class RetrieveBaristas extends BaristaManagementEvent {
  final String coffeeShopId;

  RetrieveBaristas(this.coffeeShopId);
}
