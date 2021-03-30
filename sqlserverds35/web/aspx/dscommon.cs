namespace ds2
  {
  public class dscommon
    {
    public static string ds_html_header(string title)
      {
      string header = 
        "<HTML>\n" +
        "<HEAD><TITLE>" + title + "</TITLE></HEAD>\n" +
        "<BODY>\n" +
        "<FONT FACE=\"Arial\" COLOR=\"#0000FF\">\n" +
        "<H1 ALIGN=CENTER>DVD Store</H1>\n";
      return header;
      }
    public static string ds_html_footer()
      {
      string footer = 
        "<HR>\n" +
        "<P ALIGN=CENTER>Thank You for Visiting the DVD Store!</A></P>\n" +
        "<HR>\n" +
        "<P ALIGN=CENTER>Copyright &copy; 2005 Dell</P>\n" +
        "</FONT>\n" +
        "</BODY>\n" +
        "</HTML>\n";
      return footer;
      }
    }
  }