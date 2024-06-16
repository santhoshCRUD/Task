<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Task.aspx.cs" Inherits="Task.Task" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
     <!--Knockout Script-->
 <script src="js/knockout-3.5.1.js" type="text/javascript"></script>
 <script src="js/knockout.mapping-latest-2.4.1.js" type="text/javascript"></script>
 <script src="js/knockout.validation-2.0.4.js" type="text/javascript"></script>
    <style>

    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var objUrlParams = new URLSearchParams(window.location.search);
            var Id = objUrlParams.get('Id');
            if (Id != null) {
                $("#btnSubmit").text("Update");
                $("#taskInfo").text("Update Task");

                fnEdit(Id);
            }
        });

        function fnSaveOrUpdate() {
            var isValid = false;
            if (hasText("#txtName") && hasText("#txtDeadline")) {
                isValid = true;
            }

            if (isValid) {
                var objTask = new TaskObjects();
                objTask.Id = $('#hdnId').val();
                objTask.TaskName = $('#txtName').val().trim();
                objTask.Description = $('#txtDescription').val().trim();
                objTask.Deadline = $('#txtDeadline').val();
                $("#btnSubmit").attr("disabled", true);

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "Task.aspx/SaveOrUpdateTask",
                    data: "{objTask : " + ko.toJSON(objTask) + "}",
                    dataType: "json",
                    success: function (data) {
                        if (data.d != "") {

                            var inserted = data.d;
                            if (inserted != null) {
                                location.href = "TaskList.aspx?flagId=" + data.d;

                            }
                            else
                                alert('failed to update');
                        }
                    },

                    error: function (response) {
                        alert(response.responseText);
                    },
                    failure: function (response) {
                        alert(response.responseText);
                    }
                });
            }


            return isValid;
        }
        function fnEdit(Id) {

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Task.aspx/EditTask",
                data: "{ 'Id': " + Id + " }",
                dataType: "json",
                success: function (data) {
                    if (data.d != null) {
                        $('#hdnId').val(data.d.Id);
                        $('#txtName').val(data.d.TaskName);
                        $('#txtDescription').val(data.d.Description);
                        $('#txtDeadline').val(data.d.Deadline);
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
        }

        //For validation purpose:
        function hasText(ctrlId) {

            var hasIt = true;
            if ($(ctrlId).val() == "") {
                hasIt = false;
                $(ctrlId).css({ "border-color": "red", "box-shadow": "0px 0px 3px 1px red" });
            }
            else {
                $(ctrlId).css({ "border-color": "#000", "box-shadow": "none" });

            }

            return hasIt;
        }

        function RemoveVal(ID) {
            $(ID).css({ "border-color": "#000", "box-shadow": "none" });
            $(ID).next('.select2-container').find('.select2-selection').css({ "border-color": "#000", "box-shadow": "none" });
        }
    </script>

    <div class="page-body">
        <h3 class="h-25" id="taskInfo">Add Task</h3>
</div>
    <div class="page-body">
    <div class="row">
        <div class="col-sm-12">
                <div class="col-sm-4">

    <label class="col-form-label">Task Name</label><span style="color:red">*</span>
    <input type="text" class="form-control" id="txtName" autocomplete="off" maxlength="250" placeholder="Task Name" oninput="RemoveVal(this)" required>
</div>
    <div class="col-sm-4">

    <label class="col-form-label">Description</label>
    <textarea  type="text" class="form-control" id="txtDescription" autocomplete="off" placeholder="Description" oninput="RemoveVal(this)"></textarea>
</div>
    <div class="col-sm-4">

    <label class="col-form-label">Deadline</label><span style="color:red">*</span>
    <input type="date" class="form-control" id="txtDeadline" autocomplete="off" placeholder="Deadline" onclick="RemoveVal(this)" required>
</div>
        </div>
    </div>
</div>

    <div class="col-sm-12">
    <center>
        <button type="button" class="btn btn-warning" id="btnSubmit" value="" style="" onclick="fnSaveOrUpdate()">Add</button>
        <button type="button" class="btn btn-danger" id="btnBack" value="" style="background-color: #19020b; border-color: #19020b;" onclick="location.href = 'TaskList.aspx'">Cancel</button>
    </center>
</div>

        <input type="text" id="hdnId" value="0" hidden="hidden">


     <script type="text/javascript">
         var TaskObjects = function () {
             var self = this;
             self.Id = ko.observable(0);
             self.TaskName = ko.observable('');
             self.Description = ko.observable('');
             self.Deadline = ko.observable('');
         };
     </script>
</asp:Content>
