select count(*) "Количество заказов за все время"
from orders;

select order_id, sum(unit_price * quantity * (1 - discount)) as total_sum 
from order_details
group by order_id;

select city, count(*) as people
from employees
group by city;

select
	emp.first_name || ' ' || emp.last_name as full_name,
	sum(odet.unit_price * odet.quantity * (1 - odet.discount)) as total_orders_sum
from employees emp
join orders ord on emp.employee_id = ord.employee_id
join order_details odet on ord.order_id = odet.order_id
group by emp.first_name, emp.last_name;

select
	prod.product_name,
	sum(odet.quantity) as total_quantity
from products prod 
join order_details odet on prod.product_id = odet.product_id
group by prod.product_name
order by total_quantity desc;














