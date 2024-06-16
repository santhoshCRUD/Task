<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Task._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
    <section class="row" aria-labelledby="aspnetTitle">
        <h1 id="aspnetTitle">ASP.NET CRUD Operation Project</h1>
        <p class="lead">Objective: Create a basic ASP.NET MVC or ASP.NET Core application that performs CRUD (Create, Read, Update, Delete) operations on a simple entity, such as "Task" or "Employee."</p>
        <p><button type="button" class="btn btn-warning addBtn" onclick="location.href='TaskList.aspx'" style="float: right;">Go to Task</button>
        </p>
    </section>
    
</main> 

</asp:Content>
