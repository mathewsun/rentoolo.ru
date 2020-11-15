<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Artists.aspx.cs" Inherits="Rentoolo.CraftsMan.Artists" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        @media (min-width: 576px) {
            .card-columns {
                column-count: 2;
            }
        }

        @media (min-width: 768px) {
            .card-columns {
                column-count: 3;
            }
        }

        @media (min-width: 992px) {
            .card-columns {
                column-count: 4;
            }
        }

        @media (min-width: 1200px) {
            .card-columns {
                column-count: 5;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h4 class="mb-4">Responsive .card-columns</h4>
<div class="card-columns">
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">1 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">2 Card title</h4>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">3 Card title</h4>
         <p class="card-text">Card Text..</p>
         <p class="card-text">Card Text..</p>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">4 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">5 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">6 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">7 Card title</h4>
         <p class="card-text">Card Text..</p>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">8 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
         <h4 class="card-title">9. Card title</h4>
         <p class="card-text">Card Text..</p>
         <p class="card-text">Card Text..</p>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
   <div class="card">
      <div class="card-body">
          <img class="card-img-top" src="../assets/img/instagram_10.jpg" alt="Card image">
         <h4 class="card-title">10 Card title</h4>
         <p class="card-text">Card Text..</p>
      </div>
   </div>
</div>
 
</asp:Content>
