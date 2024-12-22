class Customer:
    def calculate_discount(self):
        pass

class RegularCustomer(Customer):
    def calculate_discount(self):
        return 10

class PremiumCustomer(Customer):
    def calculate_discount(self):
        return 20

class VipCustomer(Customer):
    def calculate_discount(self):
        return 30

class DiscountCalculator:
    def calculate_discount(self, customer: Customer):
        return customer.calculate_discount()
