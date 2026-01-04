# Pizza Sales Analysis using SQL

# Project Overview
  This project focuses on analyzing pizza sales data using SQL to uncover key business insights such as revenue trends, top-selling pizzas, category-wise performance, 
  and customer order behavior. The analysis leverages joins, aggregations, CTEs, and window functions to answer real-world business questions.

# Business Requirements & Analysis Performed
  🔹 Order & Revenue Analysis
  Retrieve the total number of orders placed
  Calculate the total revenue generated from pizza sales
  Identify the highest-priced pizza
  Analyze the cumulative revenue generated over time
  Calculate the percentage contribution of each pizza type to total revenue
  
  🔹 Product Performance Analysis
  Identify the most common pizza size ordered
  List the top 5 most ordered pizza types along with their quantities
  Determine the top 3 most ordered pizza types based on revenue
  Determine the top 3 most ordered pizza types based on revenue for each pizza category
  Calculate the total quantity ordered for each pizza category
  
  🔹 Category & Distribution Analysis
  Find the category-wise distribution of pizzas
  Analyze category-wise sales performance
  Determine the distribution of orders by hour of the day
  
  🔹 Time-Based Analysis
  Group orders by date and calculate the average number of pizzas ordered per day
  Identify sales trends over time using cumulative revenue

# Dataset Description
  The dataset consists of the following tables:
  orders – Order-level information (order date, order time)
  order_details – Pizza-level order details (quantity, pizza_id)
  pizzas – Pizza size and price details
  pizza_types – Pizza name and category information
