#' @title mp_info
#'
#' @description Provides current data on an MP for a particular constituency
#' @param constituency constituency name
#' @export
#' @return Datagrame
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

  career_url<-paste0(link_info,"/career")
  #constit_id
  #number_elected
  #first_time
  #last_time
  #committee
  #majority
  #tunrout
  #electorate
  #vote
  #share
  #change
  #status
  first_g<-gender::gender(names=first_name,
                          method="ssa",year="2012")
  gender1<-first_g$gender


  DATA<-tibble::tibble(constituency=constituency,
                       mp_name=mp_name,
                       member_id=member_id,
                       mp_link=link_info,
                       first_name=first_name,
                       surname=surname,
                       party=party_name,
                       gender=gender1,
                       hansard_link=hansard_link
                       )
  return(DATA)
}
