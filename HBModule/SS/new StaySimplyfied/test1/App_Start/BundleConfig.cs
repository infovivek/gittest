using System.Web;
using System.Web.Optimization;

namespace test1
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));


            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js",

                        "~/Scripts/js/bootstrap-datepicker.js",
                      "~/Scripts/js/bootstrap.js",
                      "~/Scripts/js/bootstrap.min.js",
                      "~/Scripts/js/common.js",
                      "~/Scripts/js/demo.js",
                      "~/Scripts/js/jquery.autocomplete.js",
                      "~/Scripts/js/jquery.js",

                      "~/Scripts/jquery-1.10.2.js",
                      "~/Scripts/jquery-ui.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                     "~/Content/Site.css",
                      "~/Content/bootstrap.min.css",
                     "~/Content/bootstrap.css"));



            bundles.Add(new StyleBundle("~/Content/css1").Include(
                      "~/Content/css1/bootstrap-theme.css",
                      "~/Content/css1/bootstrap.css",
                      "~/Content/css1/bootstrap.min.css",
                      "~/Content/css1/datepicker.css",
                      "~/Content/css1/jquery.autocomplete.css",
                      "~/Content/css1/owl.carousel.css",
                      "~/Content/css1/owl.theme.css",
                      "~/Content/css1/style-mobile.css",
                      "~/Content/css1/style-pc.css",
                      "~/Content/style-tab.css",
                      "~/Content/css1/style.css",
                      "~/Content/css1/bootstrap-theme.min.css"));


            bundles.Add(new StyleBundle("~/Content/css2").Include(

                      "~/Content/css2/colorbox.css",
                      "~/Content/css1/custom.css",
                      "~/Content/css2/custom_ba.css",
                      "~/Content/css2/slider.css",
                       "~/Content/jquery-ui.css")); 

        }
    }
}
