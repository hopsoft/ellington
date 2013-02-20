class Billing < Ellington::Line

  stations << VerifyCreditCard.new
  stations << BillCreditCard.new
  stations << SendBillingNotification.new

  goal stations.last.passed

end
