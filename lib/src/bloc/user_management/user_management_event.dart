abstract class UserManagementEvent {}

class CreateBarista extends UserManagementEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String coffeeShopId;

  CreateBarista(this.email, this.firstName, this.lastName, this.password,
      this.coffeeShopId);
}

class RetrieveBaristas extends UserManagementEvent {
  final String coffeeShopId;

  RetrieveBaristas(this.coffeeShopId);
}
