Feature: Parse yoga class schedules from school websites

  Scenario: Parse Helsingin astanga joogakoulu's classes
    When I run the parser for Helsingin astanga joogakoulu
    Then the resulting JSON contains 5 studios

  Scenario: Parse Moola's classes 
    When I run the parser for Moola 
    Then the resulting JSON contains 1 studio
