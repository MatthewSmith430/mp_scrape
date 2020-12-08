#' @title mp_info
#'
#' @description Provides current data on an MP for a particular constituency
#' @param constituency constituency name
#' @export
#' @return Dataframe of current MP information for constituency
#'
#'
mp_info<-function(constituency){
  csearch<-gsub(" ","+",constituency)
  url<-paste0("https://members.parliament.uk/members/Commons?SearchText=",
    csearch,
    "&PartyId=&Gender=Any&ForParliament=0&ShowAdvanced=False")
  PAGE<-xml2::read_html(url)
  #url<-"https://members.parliament.uk/members/Commons"
  p_selector_name<-".primary-info"
  s_selector_name<-".secondary-info"
  c_selector_name<-".card"
  p1<-rvest::html_nodes(PAGE,css = p_selector_name)
  p2<-rvest::html_text(p1)
  p3<-gsub("\r\n","",p2)
  mp_name<-gsub("  ","",p3)
  first_name<-stringr::word(mp_name, 1)
  surname<-stringr::word(mp_name,-1)

  s1<-rvest::html_nodes(PAGE,css = s_selector_name)
  s2<-rvest::html_text(s1)
  s3<-gsub("\r\n","",s2)
  party_name<-gsub("  ","",s3)

  c1<-rvest::html_nodes(PAGE,css = c_selector_name)
  c2<-rvest::html_attr(c1,"href")

  link_info<-paste0("https://members.parliament.uk",c2)
  link_split<-strsplit(c2,"/")
  link_split2<-unlist(link_split)
  member_id<-link_split2[[3]]

  hansard_link<-paste0("https://hansard.parliament.uk/search/MemberContributions?memberId=",
                       member_id,"&type=Spoken")

  career_url<-paste0("https://members.parliament.uk/member/",member_id,"/career")
  #constit_id

  ne_select<-".secondary-info"
  CP<-xml2::read_html(career_url)
  NE1<-rvest::html_nodes(CP,css = ne_select)
  NE2<-rvest::html_text(NE1)
  NE2<-NE2[[1]]
  NE2<-gsub("\r\n","",NE2)
  NE2<-trimws(NE2)
  NE3<-readr::parse_number(NE2)

  TS<-"div.card-list:nth-child(2) > a:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)"

  TS1<-rvest::html_nodes(CP,css =TS)
  TS2<-rvest::html_text(TS1)
  TS3<-gsub("\r\n","",TS2)
  TS4<-trimws(TS3)
  time_split<-stringr::str_split(TS4,"-")
  time_split<-unlist(time_split)
  #first_time
  first1<-time_split[[1]]
  first1<-trimws(first1)
  first_date<-as.Date(first1, format = "%d %B %Y")

  first_year<-lubridate::year(first_date)
  first_month<-lubridate::month(first_date)

  #last_time
  last1<-time_split[[2]]
  last1<-trimws(last1)

  if (last1=="Present"){
    last_date<-"current"
    last_year<-"current"
    last_month<-"current"
  }else{
    last_date<-as.Date(last1, format = "%d %B %Y")
    last_year<-lubridate::year(first_date)
    last_month<-lubridate::month(first_date)
  }

  #committee
  com_select<-"div.card > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)"
  com1<-rvest::html_nodes(CP,css =com_select)
  com2<-rvest::html_text(com1)
  com3<-gsub("\r\n","",com2)
  com3<-trimws(com3)
  com3<-unique(com3)
  com4<-stringr::str_c(com3,collapse='/')

  #status
  ele_url<-paste0("https://members.parliament.uk/member/",member_id,"/electionresult")
  stat_select<-".content > div:nth-child(1)"
  EP<-xml2::read_html(ele_url)
  ele1<-rvest::html_nodes(EP,css =stat_select)
  ele2<-rvest::html_text(ele1)
  ele3<-gsub("\r\n","",ele2)
  ele3<-trimws(ele3)



  first_g<-gender::gender(names=first_name,
                          method="ssa",year="2012")
  gender1<-first_g$gender
  if(purrr::is_empty(gender1)==TRUE){
    gender1<-"NA"
  }else{gender1<-gender1}

  con2<-csearch<-gsub(" ","_",constituency)
  wiki<-paste0("https://en.wikipedia.org/wiki/",
               con2,"_(UK_Parliament_constituency)")
  webpage <- xml2::read_html(wiki)

  #GG<-".infobox > tbody:nth-child(1) > tr:nth-child(10) > td:nth-child(2) > a:nth-child(1)"
  #GG<-".infobox > tbody:nth-child(1) > tr:nth-child(11) > td:nth-child(2)"
  GG<-".infobox > tbody:nth-child(1) > tr:nth-child(11) > td:nth-child(2) > a:nth-child(1)"
  #CS selector
  #.infobox > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(2)

  mp1<-rvest::html_nodes(webpage,css = GG)
  LEN_MP<-length(mp1)
  if (LEN_MP==0){
    GA<-".infobox > tbody:nth-child(1) > tr:nth-child(8) > td:nth-child(2) > a:nth-child(1)"
    mpA<-rvest::html_nodes(webpage,css = GA)
    mp2<-rvest::html_attr(mpA,"href")

  }else{mp2<-rvest::html_attr(mp1,"href")}

  if(purrr::is_empty(mp2)){
    GB<-".infobox > tbody:nth-child(1) > tr:nth-child(10) > td:nth-child(2) > a:nth-child(1)"
    mpB<-rvest::html_nodes(webpage,css = GB)
    mp2<-rvest::html_attr(mpB,"href")
  }else{mp2<-mp2}

  mp_link1<-paste0("https://en.wikipedia.org/",
                   mp2)

  mppage <- xml2::read_html(mp_link1)
  mp_node<-rvest::html_nodes(mppage,"table.vcard")
  mp_tab<-rvest::html_table(mp_node,header=F,fill = TRUE)
  data_tab<-mp_tab[[1]]
  DOB<-dplyr::filter(data_tab,X1=="Born")
  DOB1<-gsub(" ","",DOB$X2)
  DOB2<-stringr::str_split(DOB1,"[(]",
                          simplify = T)
  DOB3<-stringr::str_split(DOB2,"[)]",
                          simplify = T)
  DOB_data<-DOB3[2,1]
  #ymd
  DOB_split<-stringr::str_split(DOB_data,"-")
  DOB_split<-unlist(DOB_split)
  birth_year<-DOB_split[[1]]
  birth_month<-DOB_split[[2]]
  birth_day<-DOB_split[[3]]

  nat1<-dplyr::filter(data_tab,X1=="Nationality")
  nat2<-nat1$X2
  CN<-purrr::is_empty(nat2)
  if (CN==TRUE){
    nat3<-NA
  }else{nat3<-nat2}

  am1<-dplyr::filter(data_tab,X1=="Alma mater")
  am2<-am1$X2
  CHECK<-purrr::is_empty(am2)
  if (CHECK==TRUE){
    am3<-"NA"
  }else{am3<-am2}
  DATA<-tibble::tibble(constituency=constituency,
                       constituency_status=ele3,
                       mp_name=mp_name,
                       member_id=member_id,
                       mp_link=link_info,
                       first_name=first_name,
                       surname=surname,
                       party=party_name,
                       first_date=first_date,
                       first_month=first_month,
                       first_year=first_year,
                       last_date=last_date,
                       last_month=last_month,
                       last_year=last_year,
                       number_times_elected=NE3,
                       membership_post_gov_opp_committee=com4,
                       gender=gender1,
                       dob=DOB_data,
                       birth_year=birth_year,
                       birth_month=birth_month,
                       birth_day=birth_day,
                       natioanlity=nat3,
                       alma_mater=am3,
                       hansard_link=hansard_link
                       )
  return(DATA)
}
