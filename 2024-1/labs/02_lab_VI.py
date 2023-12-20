import wooldridge
import pandas as pd

# Load the mroz dataset
mroz = wooldridge.data("mroz")

# Filter out observations where salary is missing
mroz = mroz[mroz["wage"].notna()]

mroz.describe()
