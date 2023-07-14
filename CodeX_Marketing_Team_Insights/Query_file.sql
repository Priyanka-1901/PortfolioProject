# I have made a view resp_detail by joining dim_cities, dim_respondents and fact_survey_responses
Select * from resp_detail

# Who prefers energy drink more (male/female/non-binary) 
# Male
Select gender, count(response_id) as Consumers_Count
from resp_detail
group by gender;

# Which age group prefers energy drinks more
# 15-30
Select age, count(response_id) as Consumers_Count
from resp_detail
group by age;

# Which type of marketing reaches the most Youth (15-30)
# Online ads
Select marketing_channels, count(marketing_channels) as Youth_Reach_Count
from resp_detail
where age in ("15-18", "19-30")
group by marketing_channels
order by Youth_Reach_Count desc;

# What are the preferred ingredients of energy drinks among respondents
# Caffeine
Select ingredients_expected, count(response_id) as Consumers_Count
from resp_detail
group by ingredients_expected
order by Consumers_Count desc;

# What packaging preferences do respondents have for energy drinks
# Compact and portable cans
Select packaging_preference, count(response_id) as Consumers_Count
from resp_detail
group by  packaging_preference
order by Consumers_Count desc;

# Who are the current market leaders
# Cola-Coka, Bepsi
Select current_brands, count(response_id) as Consumers_Count
from resp_detail
group by  current_brands
order by Consumers_Count desc;

# What are the primary reasons consumers prefer those brands over ours
# Brand reputation
Select Reasons_for_choosing_brands, count(response_id) as Consumers_Count
from resp_detail
group by Reasons_for_choosing_brands
order by Consumers_Count desc;

# Which marketing channel can be used to reach more customers
# Online ads
Select marketing_channels, count(marketing_channels) as Reach_Count
from resp_detail
group by marketing_channels
order by Reach_Count desc;

# How effective are different marketing strategies and channels in reaching our customers
# Online ads	411
Select marketing_channels, count(marketing_channels) as Reach_Count
from resp_detail
where Current_brands = 'Codex'
group by marketing_channels
order by Reach_Count desc;

# What do people think about our brand by perception
# Neutral	5974
Select brand_perception, count(response_id) as Consumers_Count
from resp_detail
group by brand_perception
order by Consumers_Count desc;

# What do people think about our brand taste
# Here I am taking into account only the people who have heard and tried our drink
# 3.3
Select Taste_experience, count(response_id) as Consumers_Count
from resp_detail
where Current_brands = 'Codex'
and heard_before = 'Yes'
and tried_before = 'Yes'
group by Taste_experience
order by Consumers_Count desc;

# How many people have heard about codex before
# Majority No
Select Heard_before, count(response_id) as Consumers_Count
from resp_detail
group by Heard_before
order by Consumers_Count desc;

Select Heard_before, tried_before, count(response_id) as Consumers_Count
from resp_detail
group by Heard_before, tried_before
order by Consumers_Count desc;

# How many people have tried codex before
# 214 out of 10K
Select Current_brands, count(response_id) as Consumers_Count
from resp_detail
where Current_brands = 'Codex'
and heard_before = 'Yes'
and tried_before = 'Yes';

# Which cities do we need to focus more on
# Tier 1 cities
Select City, count(response_id) as Consumers_Count, Tier
from resp_detail
where Current_brands = 'Codex'
and heard_before = 'Yes'
group by City, Tier
order by Consumers_Count desc;

# Where do respondents prefer to purchase energy drinks
# Supermarkets
Select Purchase_location, count(response_id) as Consumers_Count
from resp_detail
group by Purchase_location
order by Consumers_Count desc;

# What are the typical consumption situations for energy drinks among respondents
# mostly Sports/exercise
Select Typical_consumption_situations, count(response_id) as Consumers_Count
from resp_detail
group by Typical_consumption_situations
order by Consumers_Count desc;

# What factors influence respondents' purchase decisions, such as price range and limited edition packaging

# What is prefered packaging 
# Compact and portable cans
Select Packaging_preference, count(response_id) as Consumers_Count
from resp_detail
group by Packaging_preference
order by Consumers_Count desc;

# Do people prefer Limited edition
# Mostly No
Select Limited_edition_packaging, count(response_id) as Consumers_Count
from resp_detail
group by Limited_edition_packaging
order by Consumers_Count desc;

# What is prefered pricing
# 50-99
Select Price_range, count(response_id) as Consumers_Count
from resp_detail
group by Price_range
order by Consumers_Count desc;

# What is General perception of all 
# Effective
Select General_perception, count(response_id) as Consumers_Count
from resp_detail
group by General_perception
order by Consumers_Count desc;

# What is the main Consumtion reason of energy drink
# Increased energy and focus
Select Consume_reason, count(response_id) as Consumers_Count
from resp_detail
group by Consume_reason
order by Consumers_Count desc;

# What is the main Consume time of energy drink
# To stay awake during work/study
Select Consume_time, count(response_id) as Consumers_Count
from resp_detail
group by Consume_time
order by Consumers_Count desc;

# What is the major Consume frequency of energy drink
# 2-3 times a week
Select Consume_frequency, count(response_id) as Consumers_Count
from resp_detail
group by Consume_frequency
order by Consumers_Count desc;

# What is the main reasons preventing trying of energy drink
# Not available locally
Select Reasons_preventing_trying, count(response_id) as Consumers_Count
from resp_detail
group by Reasons_preventing_trying
order by Consumers_Count desc;

# What is the Improvements desired in energy drink
# Reduced sugar content
Select Improvements_desired, count(response_id) as Consumers_Count
from resp_detail
group by Improvements_desired
order by Consumers_Count desc;

# What is the Ingredients expected in energy drink
# Caffeine
Select Ingredients_expected, count(response_id) as Consumers_Count
from resp_detail
group by Ingredients_expected
order by Consumers_Count desc;

# Are people intrested in natural or organic energy drink
# Yes
Select Interest_in_natural_or_organic, count(response_id) as Consumers_Count
from resp_detail
group by Interest_in_natural_or_organic 
order by Consumers_Count desc;