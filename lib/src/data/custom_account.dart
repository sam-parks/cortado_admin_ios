class CustomAccount {
  String id;
  String object;
  BusinessProfile businessProfile;
  String businessType;
  Capabilities capabilities;
  bool chargesEnabled;
  String country;
  int created;
  String defaultCurrency;
  bool detailsSubmitted;
  String email;
  ExternalAccounts externalAccounts;
  Individual individual;
  bool payoutsEnabled;
  Requirements requirements;
  Settings settings;
  TosAcceptance tosAcceptance;
  String type;

  CustomAccount(
      {this.id,
      this.object,
      this.businessProfile,
      this.businessType,
      this.capabilities,
      this.chargesEnabled,
      this.country,
      this.created,
      this.defaultCurrency,
      this.detailsSubmitted,
      this.email,
      this.externalAccounts,
      this.individual,
      this.payoutsEnabled,
      this.requirements,
      this.settings,
      this.tosAcceptance,
      this.type});

  CustomAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    businessProfile = json['business_profile'] != null
        ? new BusinessProfile.fromJson(json['business_profile'])
        : null;
    businessType = json['business_type'];
    capabilities = json['capabilities'] != null
        ? new Capabilities.fromJson(json['capabilities'])
        : null;
    chargesEnabled = json['charges_enabled'];
    country = json['country'];
    created = json['created'];
    defaultCurrency = json['default_currency'];
    detailsSubmitted = json['details_submitted'];
    email = json['email'];
    externalAccounts = json['external_accounts'] != null
        ? new ExternalAccounts.fromJson(json['external_accounts'])
        : null;
    individual = json['individual'] != null
        ? new Individual.fromJson(json['individual'])
        : null;
    payoutsEnabled = json['payouts_enabled'];
    requirements = json['requirements'] != null
        ? new Requirements.fromJson(json['requirements'])
        : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    tosAcceptance = json['tos_acceptance'] != null
        ? new TosAcceptance.fromJson(json['tos_acceptance'])
        : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    if (this.businessProfile != null) {
      data['business_profile'] = this.businessProfile.toJson();
    }
    data['business_type'] = this.businessType;
    if (this.capabilities != null) {
      data['capabilities'] = this.capabilities.toJson();
    }
    data['charges_enabled'] = this.chargesEnabled;
    data['country'] = this.country;
    data['created'] = this.created;
    data['default_currency'] = this.defaultCurrency;
    data['details_submitted'] = this.detailsSubmitted;
    data['email'] = this.email;
    if (this.externalAccounts != null) {
      data['external_accounts'] = this.externalAccounts.toJson();
    }
    if (this.individual != null) {
      data['individual'] = this.individual.toJson();
    }
    data['payouts_enabled'] = this.payoutsEnabled;
    if (this.requirements != null) {
      data['requirements'] = this.requirements.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    if (this.tosAcceptance != null) {
      data['tos_acceptance'] = this.tosAcceptance.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class BusinessProfile {
  String mcc;
  String name;
  String productDescription;
  dynamic supportAddress;
  dynamic supportEmail;
  String supportPhone;
  dynamic supportUrl;
  String url;

  BusinessProfile(
      {this.mcc,
      this.name,
      this.productDescription,
      this.supportAddress,
      this.supportEmail,
      this.supportPhone,
      this.supportUrl,
      this.url});

  BusinessProfile.fromJson(Map<String, dynamic> json) {
    mcc = json['mcc'];
    name = json['name'];
    productDescription = json['product_description'];
    supportAddress = json['support_address'];
    supportEmail = json['support_email'];
    supportPhone = json['support_phone'];
    supportUrl = json['support_url'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mcc'] = this.mcc;
    data['name'] = this.name;
    data['product_description'] = this.productDescription;
    data['support_address'] = this.supportAddress;
    data['support_email'] = this.supportEmail;
    data['support_phone'] = this.supportPhone;
    data['support_url'] = this.supportUrl;
    data['url'] = this.url;
    return data;
  }
}

class Capabilities {
  String cardPayments;
  String transfers;

  Capabilities({this.cardPayments, this.transfers});

  Capabilities.fromJson(Map<String, dynamic> json) {
    cardPayments = json['card_payments'];
    transfers = json['transfers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_payments'] = this.cardPayments;
    data['transfers'] = this.transfers;
    return data;
  }
}

class ExternalAccounts {
  String object;
  List<ExternalAccount> externalAccounts;
  bool hasMore;
  String url;

  ExternalAccounts({this.object, this.externalAccounts, this.hasMore, this.url});

  ExternalAccounts.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['data'] != null) {
      externalAccounts = new List<ExternalAccount>();
      json['data'].forEach((v) {
        externalAccounts.add(new ExternalAccount.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    if (this.externalAccounts != null) {
      data['data'] = this.externalAccounts.map((v) => v.toJson()).toList();
    }
    data['has_more'] = this.hasMore;
    data['url'] = this.url;
    return data;
  }
}

class ExternalAccount {
  String id;
  String object;
  String account;
  dynamic accountHolderName;
  dynamic accountHolderType;
  String bankName;
  String country;
  String currency;
  bool defaultForCurrency;
  String fingerprint;
  String last4;
  String routingNumber;
  String status;

  ExternalAccount(
      {this.id,
      this.object,
      this.account,
      this.accountHolderName,
      this.accountHolderType,
      this.bankName,
      this.country,
      this.currency,
      this.defaultForCurrency,
      this.fingerprint,
      this.last4,
      this.routingNumber,
      this.status});

  ExternalAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    account = json['account'];
    accountHolderName = json['account_holder_name'];
    accountHolderType = json['account_holder_type'];
    bankName = json['bank_name'];
    country = json['country'];
    currency = json['currency'];
    defaultForCurrency = json['default_for_currency'];
    fingerprint = json['fingerprint'];
    last4 = json['last4'];
    routingNumber = json['routing_number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['account'] = this.account;
    data['account_holder_name'] = this.accountHolderName;
    data['account_holder_type'] = this.accountHolderType;
    data['bank_name'] = this.bankName;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['default_for_currency'] = this.defaultForCurrency;
    data['fingerprint'] = this.fingerprint;
    data['last4'] = this.last4;
    data['routing_number'] = this.routingNumber;
    data['status'] = this.status;
    return data;
  }
}

class Individual {
  String id;
  String object;
  String account;
  Address address;
  int created;
  Dob dob;
  String email;
  String firstName;
  bool idNumberProvided;
  String lastName;
  Relationship relationship;
  Requirements requirements;
  bool ssnLast4Provided;
  Verification verification;

  Individual(
      {this.id,
      this.object,
      this.account,
      this.address,
      this.created,
      this.dob,
      this.email,
      this.firstName,
      this.idNumberProvided,
      this.lastName,
      this.relationship,
      this.requirements,
      this.ssnLast4Provided,
      this.verification});

  Individual.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    account = json['account'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    created = json['created'];
    dob = json['dob'] != null ? new Dob.fromJson(json['dob']) : null;
    email = json['email'];
    firstName = json['first_name'];
    idNumberProvided = json['id_number_provided'];
    lastName = json['last_name'];
    relationship = json['relationship'] != null
        ? new Relationship.fromJson(json['relationship'])
        : null;
    requirements = json['requirements'] != null
        ? new Requirements.fromJson(json['requirements'])
        : null;
    ssnLast4Provided = json['ssn_last_4_provided'];
    verification = json['verification'] != null
        ? new Verification.fromJson(json['verification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['account'] = this.account;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['created'] = this.created;
    if (this.dob != null) {
      data['dob'] = this.dob.toJson();
    }
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['id_number_provided'] = this.idNumberProvided;
    data['last_name'] = this.lastName;

    if (this.relationship != null) {
      data['relationship'] = this.relationship.toJson();
    }
    if (this.requirements != null) {
      data['requirements'] = this.requirements.toJson();
    }
    data['ssn_last_4_provided'] = this.ssnLast4Provided;
    if (this.verification != null) {
      data['verification'] = this.verification.toJson();
    }
    return data;
  }
}

class Address {
  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

  Address(
      {this.city,
      this.country,
      this.line1,
      this.line2,
      this.postalCode,
      this.state});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    line1 = json['line1'];
    line2 = json['line2'];
    postalCode = json['postal_code'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['postal_code'] = this.postalCode;
    data['state'] = this.state;
    return data;
  }
}

class Dob {
  int day;
  int month;
  int year;

  Dob({this.day, this.month, this.year});

  Dob.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}

class Relationship {
  bool director;
  bool executive;
  bool owner;
  dynamic percentOwnership;
  bool representative;
  String title;

  Relationship(
      {this.director,
      this.executive,
      this.owner,
      this.percentOwnership,
      this.representative,
      this.title});

  Relationship.fromJson(Map<String, dynamic> json) {
    director = json['director'];
    executive = json['executive'];
    owner = json['owner'];
    percentOwnership = json['percent_ownership'];
    representative = json['representative'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['director'] = this.director;
    data['executive'] = this.executive;
    data['owner'] = this.owner;
    data['percent_ownership'] = this.percentOwnership;
    data['representative'] = this.representative;
    data['title'] = this.title;
    return data;
  }
}

class Requirements {
  List<dynamic> currentlyDue;
  List<dynamic> errors;
  List<dynamic> eventuallyDue;
  List<dynamic> pastDue;
  List<dynamic> pendingVerification;

  Requirements(
      {this.currentlyDue,
      this.errors,
      this.eventuallyDue,
      this.pastDue,
      this.pendingVerification});

  Requirements.fromJson(Map<String, dynamic> json) {
    if (json['currently_due'] != null) {
      currentlyDue = new List<dynamic>();
      json['currently_due'].forEach((v) {
        currentlyDue.add((v));
      });
    }
    if (json['errors'] != null) {
      errors = new List<dynamic>();
      json['errors'].forEach((v) {
        errors.add((v));
      });
    }
    if (json['eventually_due'] != dynamic) {
      eventuallyDue = new List<dynamic>();
      json['eventually_due'].forEach((v) {
        eventuallyDue.add((v));
      });
    }
    if (json['past_due'] != dynamic) {
      pastDue = new List<dynamic>();
      json['past_due'].forEach((v) {
        pastDue.add((v));
      });
    }
    if (json['pending_verification'] != dynamic) {
      pendingVerification = new List<dynamic>();
      json['pending_verification'].forEach((v) {
        pendingVerification.add((v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // ignore: unrelated_type_equality_checks
    if (this.currentlyDue != dynamic) {
      data['currently_due'] = this.currentlyDue.map((v) => v.toJson()).toList();
    }
    // ignore: unrelated_type_equality_checks
    if (this.errors != dynamic) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    // ignore: unrelated_type_equality_checks
    if (this.eventuallyDue != dynamic) {
      data['eventually_due'] =
          this.eventuallyDue.map((v) => v.toJson()).toList();
    }
    // ignore: unrelated_type_equality_checks
    if (this.pastDue != dynamic) {
      data['past_due'] = this.pastDue.map((v) => v.toJson()).toList();
    }
    // ignore: unrelated_type_equality_checks
    if (this.pendingVerification != dynamic) {
      data['pending_verification'] =
          this.pendingVerification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verification {
  AdditionalDocument additionalDocument;
  dynamic details;
  dynamic detailsCode;
  AdditionalDocument document;
  String status;

  Verification(
      {this.additionalDocument,
      this.details,
      this.detailsCode,
      this.document,
      this.status});

  Verification.fromJson(Map<String, dynamic> json) {
    additionalDocument = json['additional_document'] != null
        ? new AdditionalDocument.fromJson(json['additional_document'])
        : null;
    details = json['details'];
    detailsCode = json['details_code'];
    document = json['document'] != null
        ? new AdditionalDocument.fromJson(json['document'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.additionalDocument != null) {
      data['additional_document'] = this.additionalDocument.toJson();
    }
    data['details'] = this.details;
    data['details_code'] = this.detailsCode;
    if (this.document != null) {
      data['document'] = this.document.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class AdditionalDocument {
  dynamic back;
  dynamic details;
  dynamic detailsCode;
  dynamic front;

  AdditionalDocument({this.back, this.details, this.detailsCode, this.front});

  AdditionalDocument.fromJson(Map<String, dynamic> json) {
    back = json['back'];
    details = json['details'];
    detailsCode = json['details_code'];
    front = json['front'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['back'] = this.back;
    data['details'] = this.details;
    data['details_code'] = this.detailsCode;
    data['front'] = this.front;
    return data;
  }
}

class Settings {
  Branding branding;
  CardPayments cardPayments;
  Dashboard dashboard;
  Payments payments;
  Payouts payouts;

  Settings(
      {this.branding,
      this.cardPayments,
      this.dashboard,
      this.payments,
      this.payouts});

  Settings.fromJson(Map<String, dynamic> json) {
    branding = json['branding'] != null
        ? new Branding.fromJson(json['branding'])
        : null;
    cardPayments = json['card_payments'] != null
        ? new CardPayments.fromJson(json['card_payments'])
        : null;
    dashboard = json['dashboard'] != null
        ? new Dashboard.fromJson(json['dashboard'])
        : null;
    payments = json['payments'] != null
        ? new Payments.fromJson(json['payments'])
        : null;
    payouts =
        json['payouts'] != null ? new Payouts.fromJson(json['payouts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.branding != null) {
      data['branding'] = this.branding.toJson();
    }
    if (this.cardPayments != null) {
      data['card_payments'] = this.cardPayments.toJson();
    }
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard.toJson();
    }
    if (this.payments != null) {
      data['payments'] = this.payments.toJson();
    }
    if (this.payouts != null) {
      data['payouts'] = this.payouts.toJson();
    }
    return data;
  }
}

class Branding {
  dynamic icon;
  dynamic logo;
  dynamic primaryColor;
  dynamic secondaryColor;

  Branding({this.icon, this.logo, this.primaryColor, this.secondaryColor});

  Branding.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    logo = json['logo'];
    primaryColor = json['primary_color'];
    secondaryColor = json['secondary_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['logo'] = this.logo;
    data['primary_color'] = this.primaryColor;
    data['secondary_color'] = this.secondaryColor;
    return data;
  }
}

class CardPayments {
  DeclineOn declineOn;
  dynamic statementDescriptorPrefix;

  CardPayments({this.declineOn, this.statementDescriptorPrefix});

  CardPayments.fromJson(Map<String, dynamic> json) {
    declineOn = json['decline_on'] != null
        ? new DeclineOn.fromJson(json['decline_on'])
        : null;
    statementDescriptorPrefix = json['statement_descriptor_prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.declineOn != null) {
      data['decline_on'] = this.declineOn.toJson();
    }
    data['statement_descriptor_prefix'] = this.statementDescriptorPrefix;
    return data;
  }
}

class DeclineOn {
  bool avsFailure;
  bool cvcFailure;

  DeclineOn({this.avsFailure, this.cvcFailure});

  DeclineOn.fromJson(Map<String, dynamic> json) {
    avsFailure = json['avs_failure'];
    cvcFailure = json['cvc_failure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avs_failure'] = this.avsFailure;
    data['cvc_failure'] = this.cvcFailure;
    return data;
  }
}

class Dashboard {
  String displayName;
  String timezone;

  Dashboard({this.displayName, this.timezone});

  Dashboard.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['timezone'] = this.timezone;
    return data;
  }
}

class Payments {
  String statementDescriptor;
  dynamic statementDescriptorKana;
  dynamic statementDescriptorKanji;

  Payments(
      {this.statementDescriptor,
      this.statementDescriptorKana,
      this.statementDescriptorKanji});

  Payments.fromJson(Map<String, dynamic> json) {
    statementDescriptor = json['statement_descriptor'];
    statementDescriptorKana = json['statement_descriptor_kana'];
    statementDescriptorKanji = json['statement_descriptor_kanji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statement_descriptor'] = this.statementDescriptor;
    data['statement_descriptor_kana'] = this.statementDescriptorKana;
    data['statement_descriptor_kanji'] = this.statementDescriptorKanji;
    return data;
  }
}

class Payouts {
  bool debitNegativeBalances;
  Schedule schedule;
  dynamic statementDescriptor;

  Payouts(
      {this.debitNegativeBalances, this.schedule, this.statementDescriptor});

  Payouts.fromJson(Map<String, dynamic> json) {
    debitNegativeBalances = json['debit_negative_balances'];
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
    statementDescriptor = json['statement_descriptor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['debit_negative_balances'] = this.debitNegativeBalances;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.toJson();
    }
    data['statement_descriptor'] = this.statementDescriptor;
    return data;
  }
}

class Schedule {
  int delayDays;
  String interval;

  Schedule({this.delayDays, this.interval});

  Schedule.fromJson(Map<String, dynamic> json) {
    delayDays = json['delay_days'];
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delay_days'] = this.delayDays;
    data['interval'] = this.interval;
    return data;
  }
}

class TosAcceptance {
  int date;
  String ip;
  dynamic userAgent;

  TosAcceptance({this.date, this.ip, this.userAgent});

  TosAcceptance.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    ip = json['ip'];
    userAgent = json['user_agent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['ip'] = this.ip;
    data['user_agent'] = this.userAgent;
    return data;
  }
}
