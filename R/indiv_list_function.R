#' @title indiv_list
#'
#' @description indiv_list
#' @param type
#' @export
#' @return
#'
#'
indiv_list<-function(type){
  if (type=="MP"){
    PAGE<-xml2::read_html(url)
    url<-"https://members.parliament.uk/members/Commons"
    selector_name<-".card-list"
    selector_name<-"a.card:nth-child(1)"
    fnames<-PAGE%>%
      html_nodes(css = selector_name) %>%
      html_text()
    other<-gsub("\r\n","",fnames)
    other2<-gsub("  ","",other)
  }
}
