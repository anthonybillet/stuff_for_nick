view: dt_engagement_facts_for_kamana {
  derived_table: {
    sql: 
        SELECT  ae.engagements_id AS engagement_id, --line 3 in your query
                MAX(ae.inserted_at) AS engagement_inserted_at --line 5 in your query
                MAX(CASE WHEN es.status = 'placed' THEN es.event_inserted_at ELSE NULL END) as engagement_placed_at, --line 40 in your query
                MAX(CASE WHEN es.status = 'cleared' THEN es.event_inserted_at ELSE NULL END) AS engagement_cleared_at --line 32 in your query
                --, .... can add more timestamps or other engagement_facts columns we may need later
        FROM audit_events ae
        JOIN engagement_status_changes es ON ae.engagements_id = es.engagements_id
        --.... can add more joins as needed later
        ;;
  }
  
#VVV BASE Dimensions auto generated by Looker VVV
  
  dimension: engagement_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.engagement_id ;;
  }
  
  dimension_group: engagement_inserted_at {
    type: time
    sql: ${TABLE}.engagement_inserted_at ;;
  }
  
  dimension_group: engagement_placed_at {
    type: time
    sql: ${TABLE}.engagement_placed_at ;;
  }
  
  dimension_group: engagement_cleared_at {
    type: time
    sql: ${TABLE}.engagement_cleared_at ;;
  }
  
#VVV Calculation of time Deltas usisng type:duration to make it easy VVV
  
  dimension_group: placed_to_cleared {
    type: duration
    sql_start: ${engagement_placed_at_raw} ;;
    sql_end: ${engagement_cleared_at_raw} ;;
  }
  
  dimension_group: inserted_to_cleared {
    type: duration
    sql_start: ${engagement_inserted_at_raw} ;;
    sql_end: ${engagement_placed_at_raw} ;;
  }
  
 #... any other duration calcs we need to make later

#VVV Measures we use to plot things like average,total duration etc on the y axis VVV
  
  measure: total_days_placed_to_cleared {
    type: sum
    sql: ${days_placed_to_cleared} ;;
  }
  
  measure: avg_days_placed_to_cleared {
    type: average
    sql: ${days_placed_to_cleared} ;;
  }
  
  measure: total_days_inserted_to_cleared {
    type: sum
    sql: ${days_inserted_to_cleared} ;;
  }
  
  measure: avg_days_inserted_to_cleared {
    type: average
    sql: ${days_inserted_to_cleared} ;;
  }
  
  # ... more measures as we need
  
  
}
