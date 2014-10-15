using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Timers;
namespace HBWindowsService
{
    public partial class Service1 : ServiceBase
    {
        Timer timer = new Timer();
        bool Flag = false;

        public Service1()
        {
            string[] St = { "", "" };

            //OnStart(St);

            new InvoiceGeneration().Invoice("RENTLOAD");

            new InvoiceGeneration().Invoice("MAINTENANCELOAD");

            new InvoiceGeneration().Invoice("BTCClient");

            new InvoiceGeneration().Invoice("MGHClient");

            new InvoiceGeneration().Invoice("ContractClosed");

            new InvoiceGeneration().Invoice("Contract Details");

            new InvoiceGeneration().Invoice("Booking Close");

            new InvoiceGeneration().Invoice("Booking Close Details");


            new InvoiceGeneration().Invoice("Booking Close");
        }
        public void onDebug()
        {
            new InvoiceGeneration().Invoice("Booking Close");
        }

        protected override void OnStart(string[] args)
        {
            //handle Elapsed event
            
            timer.Elapsed += new ElapsedEventHandler(this.OnElapsedTime);
            timer.Interval = 86399999.9998272;
            //This statement is used to set interval to 1 minute (= 60,000 milliseconds)
            //if (Flag == false)
            //{
            //    Flag = true;
            //    timer.Interval = 4000;
            //}
            //else
            //{
            //    timer.Interval = 86399999.9998272;
            //}

            //

            //enabling the timer
            timer.Enabled = true;

        }
        protected override void OnStop()
        {

        }
        private void OnElapsedTime(object source, ElapsedEventArgs e)
        {
            new InvoiceGeneration().Invoice("RENTLOAD");

            new InvoiceGeneration().Invoice("MAINTENANCELOAD");

            new InvoiceGeneration().Invoice("BTCClient");

            new InvoiceGeneration().Invoice("MGHClient");

            new InvoiceGeneration().Invoice("ContractClosed");

            new InvoiceGeneration().Invoice("Contract Details");

            new InvoiceGeneration().Invoice("Booking Close");

            new InvoiceGeneration().Invoice("Booking Close Details");

        }
    }
}
