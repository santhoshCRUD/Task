<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TaskList.aspx.cs" Inherits="Task.TaskList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="js/sweet-alert.js"></script>
    <link href="js/sweetalert.css" rel="stylesheet" />
    <script>
        $(document).ready(function () {
            var objUrlParams = new URLSearchParams(window.location.search);
            var flagId = objUrlParams.get('flagId');
            if (flagId == 1) {
                alert('Task Added !');
            }
            else if (flagId == 2) {
                alert('Task Updated !');
            }
            fnTaskList();

        });

        function fnTaskList() {

            $.ajax({

                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "TaskList.aspx/GetTaskList",
                data: "{}",
                dataType: "json",
                success: function (data) {

                    formDocument().objTask().constructor();
                    if ($.fn.dataTable.isDataTable('#basic-btn')) {
                        $('#basic-btn').DataTable().clear().destroy();
                    }
                    ko.mapping.fromJS(data.d, null, formDocument);

                    $('#basic-btn').DataTable({
                        "paging": true,
                        "ordering": false,
                        responsive: true,
                        destroy: true
                    });

                },

                error: function (response) {
                    alert(response.responseText);

                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });

        }


        function fnEdit(itemI) {
            location.href = "Task.aspx?Id=" + itemI.getAttribute('Id');
        }

        function fnDelete(itemI) {
            swal({
                title: "Are you sure?",
                showCancelButton: true,
                confirmButtonClass: "btn-warning",
                confirmButtonText: "Yes",
                cancelButtonText: "No",
            },
                function (isConfirm) {
                    if (isConfirm) {
                        var Id = itemI.getAttribute('Id');

                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: "TaskList.aspx/DeleteTask",
                            data: "{ 'Id': " + Id + " }",
                            dataType: "json",
                            success: function (data) {
                                if (data.d != null) {
                                    swal.close();
                                    new PNotify({
                                        title: 'Deleted',
                                        text: 'Deleted Successfully...',
                                        icon: 'icofont icofont-info-circle',
                                        type: 'danger'
                                    });
                                    fnTaskList();
                                }
                                else {
                                    alert('Failed to load data');
                                }

                            },
                            error: function (response) {
                                alert(response.responseText);
                            },
                            failure: function (response) {
                                alert(response.responseText);
                            }
                        });
                    } else {
                        swal.close();
                    }
                });
        }

    </script>
    <div class="access" style="padding: 20px 0px 50px 0px;">
        <button type="button" class="btn btn-warning addBtn" onclick="location.href='Task.aspx'" style="float: right;">Add Task</button>
    </div>
    <div class="table-responsive">
        <table id="basic-btn" style="width: 100%" class="table table-striped table-bordered nowrap" data-bind="visible: formDocument().objTask().length > 0">
            <thead>
                <tr>
                    <th style="text-align: center;">ID</th>
                    <th style="text-align: center;">Name</th>
                    <th style="text-align: center;">Description</th>
                    <th style="text-align: center;">Deadline</th>
                    <th style="text-align: center;">Created On</th>
                    <th style="text-align: center;">Action</th>
                </tr>
            </thead>
            <tbody data-bind="foreach: formDocument().objTask()" id="body">
                <tr>
                    <td style="text-align: left"><span data-bind="text:ID"></span>1</td>
                    <td style="text-align: left"><span data-bind="text:Name"></span>Task 1</td>
                    <td style="text-align: left"><span data-bind="text:Description">Description text here...</span></td>
                    <td style="text-align: center"><span data-bind="text:Deadline">17/06/2024</span></td>
                    <td style="text-align: center"><span data-bind="text:CreatedOn"></span>16/06/2024</td>
                    <td style="text-align: center"><span>
                        <button type="button" class="btn btn-warning editBtn" data-bind="attr: { 'Id': Id}" onclick="fnEdit(this)">Edit</button>
                        <button type="button" class="btn btn-danger deleteBtn" data-bind="attr: { 'Id': Id }" onclick="fnDelete(this)">Delete</button>
                    </span></td>
                </tr>

            </tbody>
        </table>
    </div>


    <!--Knockout Script-->
    <script src="js/knockout-3.5.1.js" type="text/javascript"></script>
    <script src="js/knockout.mapping-latest-2.4.1.js" type="text/javascript"></script>
    <script src="js/knockout.validation-2.0.4.js" type="text/javascript"></script>



    <script type="text/javascript">
        var LstTask = function () {
            var self = this;


            this.objTask = ko.observableArray([{
                Id: 0, TaskName: '', Description: '', Deadline: '', CreatedOn: ''

            }]);
        };
        formDocument = ko.observable(new LstTask());
        ko.applyBindings(new LstTask(), document.getElementById("basic-btn"));
    </script>
</asp:Content>
