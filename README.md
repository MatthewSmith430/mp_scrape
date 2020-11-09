README
================

# mpsrapeR

This package scrapes MP data - it is currently a work-in-progress with
limited functions. It chiefly scrapes data from the following
[website](https://members.parliament.uk/)

The following function, `mp_info` extracts details for a current MP for
a given constituency.

``` r
library(mpscrapeR)
library(pander)
Ashton_under_Lyne<-mp_info("Ashton-under-Lyne")

pander(Ashton_under_Lyne)
```

|   constituency    | constituency\_status |   mp\_name    | member\_id |
| :---------------: | :------------------: | :-----------: | :--------: |
| Ashton-under-Lyne |     Labour Hold      | Angela Rayner |    4356    |

Table continues below

|                      mp\_link                       | first\_name | surname |
| :-------------------------------------------------: | :---------: | :-----: |
| <https://members.parliament.uk/member/4356/contact> |   Angela    | Rayner  |

Table continues below

| party  | first\_date | first\_month | first\_year | last\_date | last\_month |
| :----: | :---------: | :----------: | :---------: | :--------: | :---------: |
| Labour | 2015-05-07  |      5       |    2015     |  current   |   current   |

Table continues below

| last\_year | number\_times\_elected |                                                                                                                                                          membership\_post\_gov\_opp\_committee                                                                                                                                                           | gender |
| :--------: | :--------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----: |
|  current   |           3            | Party Chair, Labour Party/Deputy Leader of the Labour Party/National campaign co-ordinator/Deputy Leader of the Official Opposition/Shadow Secretary of State for Education/Shadow Minister (Equalities Office) (Women and Equalities)/Shadow Minister (Work and Pensions)/Opposition Whip (Commons)/Housing, Communities and Local Government Committee | female |

Table continues below

|    dob     | birth\_year | birth\_month | birth\_day | natioanlity | alma\_mater |
| :--------: | :---------: | :----------: | :--------: | :---------: | :---------: |
| 1980-03-28 |    1980     |      03      |     28     |     NA      |     NA      |

Table continues below

|                                    hansard\_link                                     |
| :----------------------------------------------------------------------------------: |
| <https://hansard.parliament.uk/search/MemberContributions?memberId=4356&type=Spoken> |
