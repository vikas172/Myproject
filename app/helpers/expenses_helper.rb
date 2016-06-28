module ExpensesHelper

	def client_full_name(client)
		return client.initial + "" + client.first_name + "" + client.last_name 
	end

	def company_name
		return "Wipro"
	end

	def get_category_expense(expense)
		return CustomCategory.find(expense.exp_category)
	end
end
