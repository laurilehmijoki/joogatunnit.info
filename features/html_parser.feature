Feature: Parse yoga class schedules from school websites

  Scenario: Parse Helsingin astanga joogakoulu's classes
    When I run the parser for Helsingin astanga joogakoulu
    Then the resulting JSON contains 5 studios
    And each studio has at least 1 weekly class
    And each class has at least name or teacher and day of week
