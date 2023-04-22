#!/usr/bin/bash

rows=300

# Generate and insert data into the customers table
for i in $(seq 1 $rows)
do
  customerID=$((i))
  firstName="Customer $i first name"
  lastName="Customer $i first name"
  address="Address $i, City"
  phoneCell=$(echo "555-555-$((1000 + RANDOM % 9000))")
  phoneOther=$(echo "555-555-$((1000 + RANDOM % 9000))")
  echo "INSERT INTO customers (CustomerID, FirstName, LastName, Address, PhoneCell, PhoneOther) VALUES ($customerID, '$firstName', '$lastName', '$address', '$phoneCell', '$phoneOther');"
done

# Generate and insert data into the rent_cost table
for year in {2000..2022}
do
  rentCost=$(printf "%.2f" $(echo "$RANDOM%10000+$RANDOM%100*0.01" | bc))
  echo "INSERT INTO rent_cost (Year, RentCost) VALUES ($year, $rentCost);"
done

# Generate and insert data into the monthly_expenses table
for year in {2000..2022}
do
  for month in {1..12}
  do
    electricCost=$(printf "%.2f" $(echo "$RANDOM%500+$RANDOM%100*0.01" | bc))
    waterCost=$(printf "%.2f" $(echo "$RANDOM%500+$RANDOM%100*0.01" | bc))
    heatCost=$(printf "%.2f" $(echo "$RANDOM%500+$RANDOM%100*0.01" | bc))
    echo "INSERT INTO monthly_expenses (Year, Month, ElectricCost, WaterCost, HeatCost) VALUES ($year, $month, $electricCost, $waterCost, $heatCost);"
  done
done

# Generate and insert data into the cars table
for i in $(seq 1 $rows)
do
  carID=$((i))
  plateNumber="$(echo {A..Z} | tr ' ' '\n' | shuf -n 3 | tr -d '\n') $(shuf -i 100-999 -n 1)"
  province=$(shuf -n 1 -e "Ontario" "Quebec" "Nova Scotia" "New Brunswick" "Manitoba" "British Columbia" "Prince Edward Island" "Saskatchewan" "Alberta" "Newfoundland and Labrador")
  colour=$(shuf -n 1 -e "Black" "White" "Gray" "Silver" "Red" "Blue" "Green" "Yellow" "Orange" "Purple" "Brown")
  year=$((RANDOM % 25 + 1995))
  make=$(shuf -n 1 -e "Toyota" "Honda" "Ford" "Chevrolet" "Nissan" "Jeep" "Subaru" "Mazda" "Kia" "Hyundai")
  model=$(shuf -n 1 -e "Corolla" "Civic" "Focus" "Impala" "Sentra" "Wrangler" "Forester" "3" "Soul" "Elantra")
  type=$(shuf -n 1 -e "Sedan" "Coupe" "SUV" "Truck" "Van")
  echo "INSERT INTO cars (CarID, PlateNumber, Province, Colour, Year, Make, Model, Type) VALUES ($carID, '$plateNumber', '$province', '$colour', $year, '$make', '$model', '$type');"
done

# Generate and insert data into the car_purchases table
for i in $(seq 1 $rows)
do
  purchaseID=$((i))
  customerID=$((i))
  price=$(printf "%.2f" $(echo "$RANDOM%10000+$RANDOM%100*0.01" | bc))
  date=$(shuf -n 1 -i $(date -d "2000-01-01" +%s)-$(date +%s) | xargs -I{} date -d "@{}" +"%Y-%m-%d")
  carID=$((i))
  echo "INSERT INTO car_purchases (PurchaseID, CustomerID, Price, Date, CarID) VALUES ($purchaseID, $customerID, $price, '$date', $carID);"
done

# Generate and insert data into the cars_for_sale table
for i in $(seq 1 $rows)
do
  carID=$((i))
  price=$(printf "%.2f" $(echo "$RANDOM%10000+$RANDOM%100*0.01" | bc))
  kilometres=$((RANDOM % 100000 + 10000))
  purchaseID=$((i))
  echo "INSERT INTO cars_for_sale (CarID, Price, Kilometres, PurchaseID) VALUES ($carID, $price, $kilometres, $purchaseID);"
done

# Generate and insert data into the car_sales table
for i in $(seq 1 $rows)
do
  saleID=$((i))
  customerID=$((i))
  price=$(printf "%.2f" $(echo "$RANDOM%10000+$RANDOM%100*0.01" | bc))
  date=$(shuf -n 1 -i $(date -d "2000-01-01" +%s)-$(date +%s) | xargs -I{} date -d "@{}" +"%Y-%m-%d")
  carID=$((i))
  echo "INSERT INTO car_sales (SaleID, CustomerID, Price, Date, CarID) VALUES ($saleID, $customerID, $price, '$date', $carID);"
done

# Generate and insert data into the transactions table
for i in $(seq 1 $rows)
do
  transactionID=$((i))
  customerID=$((i))
  charge=$(printf "%.2f" $(echo "$RANDOM%5000+$RANDOM%100*0.01" | bc))
  date=$(shuf -n 1 -i $(date -d "2000-01-01" +%s)-$(date +%s) | xargs -I{} date -d "@{}" +"%Y-%m-%d")
  carID=$((i))
  echo "INSERT INTO transactions (TransactionID, CustomerID, Charge, Date, CarID) VALUES ($transactionID, $customerID, $charge, '$date', $carID);"
done





