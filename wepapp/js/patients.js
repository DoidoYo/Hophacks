$(document).ready(function () {

    $("#logout").click(function () {
        firebase.auth().signOut().then(function () {
            location.href = "login.html"
        }, function (error) {
            // An error happened.
        });

    });


    firebase.auth().signInWithEmailAndPassword("doc@gmail.com", "test123").catch(function (error) {
        // Handle Errors here.
        var errorCode = error.code;
        var errorMessage = error.message;
        // ...
    });
    var patients = []
    firebase.auth().onAuthStateChanged(function (user) {
        if (user) {


            //set physician code
            firebase.database().ref("Users/" + user.uid).once('value').then(function (snapshot) {
                $("#code").text(snapshot.val().code);
            });

            //get patients
            firebase.database().ref("Physicians/" + user.uid).once('value').then(function (snapshot) {
                snapshot.forEach(function (child) {

                    patients.forEach(function (item) {
                        var iid = new String(item.id);
                        var oid = new String(patient.id);

                        if (iid === oid) {
                            console.log("YES");
                        }
                    });

                    firebase.database().ref("Users/" + child.val().id).once('value').then(function (snapshot) {

                        var val = snapshot.val();
                        var patient = {
                            dob: val.dob,
                            first_name: val.first_name,
                            last_name: val.last_name,
                            id: child.val().id
                        };


                        patients.push(patient);
                        var patientIndex = patients.indexOf(patient);


                        let patientHTML = $("#template").clone();
                        patientHTML.attr('id', patientIndex);
                        patientHTML.css("position", "relative");
                        patientHTML.find(".firstname").text(patient.first_name);
                        patientHTML.find(".lastname").text(patient.last_name);
                        patientHTML.find(".dob").text(patient.dob);

                        //                        TODO
                        //Status
                        //Picture

                        patientHTML.show();

                        $("#patientTable tbody").append(patientHTML);


                        patientHTML.find("td").each(function (element) {

                            $(this).click(function () {
                                var id = patientHTML.attr('id');
                                //alert(patients[id].id);
                                sessionStorage.setItem("patient", patients[id].id)

                                if (this === patientHTML.find("td:last-child").get(0)) {


                                    firebase.database().ref("Users/" + patients[id].id).once('value').then(function (snapshot) {

                                        sessionStorage.setItem("chatId", snapshot.val().chat)

                                        window.location.href = "chat.html";
                                    });

                                } else {
                                    window.location.href = "readings.html";

                                }

                            });

                        });







                    });
                });
            });


        } else {
            //location.href = "login.html"
        }
    });


});
