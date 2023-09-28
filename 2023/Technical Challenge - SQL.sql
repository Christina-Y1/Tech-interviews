# You could run and check my query at https://sqliteonline.com/; 
# I received error in the http://sqlfiddle.com/ while using Window Function at SQLLite, so I worked with site above

with t AS (
select 
  o.user_id, 
  round(julianday(current_date) - julianday(signed_up_time)) as days_signed_up,
  count(o.id) as total_orders,
  round(avg(total_price)) as average_order_value,
  max(time(creation_time)) as time_last_order_placed
from orders o
inner join users u on u.id = o.user_id
group by o.user_id
having total_orders >= 5 
  ),
orders_count_in_store AS (
  select 
    user_id, 
    store_id, 
    count(id) as order_cnt,
    max(creation_time) as last_order_ts
  from orders 
  group by user_id, store_id
),
stores_with_order_cnt_rank AS (
  select
    user_id,
    store_id,
    order_cnt,
    last_order_ts,
    rank() OVER(PARTITION BY user_id ORDER BY order_cnt DESC) AS order_cnt_rank,
    row_number() OVER(PARTITION BY user_id, order_cnt ORDER BY last_order_ts DESC) AS last_order_rn
  from orders_count_in_store
),
favourite_shops AS (
  select user_id, store_id
  from stores_with_order_cnt_rank 
  where order_cnt_rank = 1 and last_order_rn = 1
),
total_status AS (
select 
  user_id, 
  count(final_status) as total_cnt
from orders 
group by user_id
),
delivered_status AS (
select 
  user_id, 
  final_status,
  count(id) as cnt
from orders 
Where final_status = 'DeliveredStatus'
group by user_id, final_status
),
percent_delivered_orders AS (
select t.user_id, round((cnt * 1.0 / total_cnt) * 100,2) as percent_delivered
from total_status t
left join delivered_status d on t.user_id = d.user_id 
  ),
diff_between_last_orders AS (
SELECT 
  user_id,
  round(julianday(previous_order) - julianday(second_last_order)) as diff_previous_order_second_last_order
FROM (
  select 
    user_id, 
    creation_time as previous_order,
    LAG(creation_time) over(partition by user_id order by creation_time) as  second_last_order,
    rank() over(partition by user_id order by creation_time desc) as rn
  from orders)
where rn = 1
)
select 
  t.user_id,
    days_signed_up,
    total_orders,
    average_order_value,
  s.name as name_favourite_restaurant, 
    percent_delivered, 
    time_last_order_placed,
    diff_previous_order_second_last_order
from t
left join favourite_shops f on t.user_id = f.user_id
inner join stores s on f.store_id = s.id
inner join percent_delivered_orders p on t.user_id = p.user_id
inner join diff_between_last_orders d on t.user_id = d.user_id