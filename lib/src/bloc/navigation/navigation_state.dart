part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  const NavigationState(
      this.cortadoAdminScreen, this.currentMenuItem, this.menuItems);

  final CortadoAdminScreen cortadoAdminScreen;
  final MenuItem currentMenuItem;
  final List<MenuItem> menuItems;

  @override
  List<Object> get props => [cortadoAdminScreen, currentMenuItem];
}

class NavigationInitial extends NavigationState {
  NavigationInitial(CortadoAdminScreen cortadoAdminScreen,
      MenuItem selectedMenuItem, List<MenuItem> menuItems)
      : super(cortadoAdminScreen, selectedMenuItem, menuItems);
}

enum CortadoAdminScreen { dashboard, orders, revenue, menu, customers, profile }

extension CortadoAdminScreenExtension on CortadoAdminScreen {
  String get name {
    switch (this) {
      case CortadoAdminScreen.dashboard:
        return "Dashboard";
        break;
      case CortadoAdminScreen.orders:
        return "Orders";
        break;
      case CortadoAdminScreen.revenue:
        return "Revenue";
        break;
      case CortadoAdminScreen.menu:
        return "Menu";
        break;
      case CortadoAdminScreen.customers:
        return "Customers";
        break;
      case CortadoAdminScreen.profile:
        return "Profile";
        break;
      default:
        return "Dashboard";
    }
  }
}

CortadoAdminScreen screenFromString(String name) {
  switch (name) {
    case "Dashboard":
      return CortadoAdminScreen.dashboard;
      break;
    case "Orders":
      return CortadoAdminScreen.orders;
      break;
    case "Revenue":
      return CortadoAdminScreen.revenue;
      break;
    case "Menu":
      return CortadoAdminScreen.menu;
      break;
    case "Customers":
      return CortadoAdminScreen.customers;
      break;
    case "Profile":
      return CortadoAdminScreen.profile;
      break;
    default:
      return CortadoAdminScreen.dashboard;
  }
}

class MenuItem {
  String title;
  Widget icon;
  Color color;
  int index;

  MenuItem(this.title, this.icon, this.color, this.index);
}

final baristaMenuItems = [
  MenuItem("Dashboard", Icon(Icons.dashboard, color: AppColors.cream),
      AppColors.light, 0),
  MenuItem(
      "Orders", Icon(Icons.list, color: AppColors.cream), AppColors.light, 1),
  MenuItem("Menu", Icon(Icons.local_drink, color: AppColors.cream),
      AppColors.light, 2),
];

final ownerMenuItems = [
  MenuItem("Dashboard", Icon(Icons.dashboard, color: AppColors.cream),
      AppColors.light, 0),
  MenuItem(
      "Orders", Icon(Icons.list, color: AppColors.cream), AppColors.light, 1),
  MenuItem("Revenue", Icon(Icons.attach_money, color: AppColors.cream),
      AppColors.light, 2),
  MenuItem("Menu", Icon(Icons.local_drink, color: AppColors.cream),
      AppColors.light, 3),
  MenuItem("Customers", Icon(Icons.people_outline, color: AppColors.cream),
      AppColors.light, 4),
  MenuItem(
      "Profile", Icon(Icons.person, color: AppColors.cream), AppColors.light, 5)
];

final superUserMenuItems = [
  MenuItem("Payments", Icon(Icons.payment, color: AppColors.cream),
      AppColors.light, 0),
  MenuItem("Coffee Shops", Icon(Icons.home, color: AppColors.cream),
      AppColors.light, 1),
  MenuItem("Customers", Icon(Icons.people_outline, color: AppColors.cream),
      AppColors.light, 2),
  MenuItem(
      "Profile", Icon(Icons.person, color: AppColors.cream), AppColors.light, 3)
];
