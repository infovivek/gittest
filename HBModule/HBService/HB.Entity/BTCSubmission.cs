using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HB.Entity
{
    public class BTCSubmission
    {
        public string Mode { get; set; }

        public int ModeId { get; set; }

        public decimal Amount { get; set; }

        public string ReceivedDate { get; set; }

        public string ReceivedBy { get; set; }

        public string CardBrand { get; set; }

        public string Nameoncard { get; set; }

        public string CardNumber { get; set; }

        public string ExpiryMonth { get; set; }

        public string ExpiryYear { get; set; }

        public string ROC { get; set; }

        public string SOC { get; set; }

        public string Swipedfor { get; set; }

        public string Remarks { get; set; }

        public string ChequeNo { get; set; }

        public string Bank { get; set; }

        public string DateIssued { get; set; }

        public string ReferenceNo { get; set; }

        //public string Mode { get; set; }
        //HEADER
        public string Acknowledged { get; set; }

        public string Comments { get; set; }

        public string Filename { get; set; }

        public string Physical { get; set; }

        public string Expected { get; set; }

        public string SubmittedOn { get; set; }

        public int ClientId { get; set; }

        public string CollectionStatus { get; set; }

        public int Id { get; set; }

        //DETAILS
        public string InvoiceNo { get; set; }

        public string InvoiceType { get; set; }

        public string InvoiceDate { get; set; }

        public int DepositDetilsId { get; set; }

        public int ChkOutHdrId { get; set; }

        public int DetailsId { get; set; }

    }
}
