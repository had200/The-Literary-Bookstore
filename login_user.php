<?php
include('db.php');  // Inclusion du fichier de connexion à la base de données

// Récupère les données envoyées en POST
$data = json_decode(file_get_contents("php://input"));

// Vérifie si les champs email et mot de passe sont présents
if (isset($data->email) && isset($data->password)) {
    $email = $data->email;
    $password = $data->password;

    // Prépare la requête pour rechercher l'utilisateur dans la base de données
    $sql = "SELECT id, name, email, password FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);  // Bind l'email à la requête
    $stmt->execute();
    $result = $stmt->get_result();

    // Si l'utilisateur existe
    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Vérifie si le mot de passe correspond (utilisation de password_verify si le mot de passe est crypté)
        if (password_verify($password, $user['password'])) {
            // Si la connexion réussie, renvoyer un succès avec les données de l'utilisateur
            echo json_encode([
                'success' => true,
                'user' => [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'email' => $user['email']
                ]
            ]);
        } else {
            // Si le mot de passe ne correspond pas
            echo json_encode([
                'success' => false,
                'error' => ''
            ]);
        }
    } else {
        // Si l'utilisateur n'est pas trouvé
        echo json_encode([
            'success' => false,
            'error' => 'user not found'
        ]);
    }

    $stmt->close();
} else {
    // Si les champs ne sont pas fournis
    echo json_encode([
        'success' => false,
        'error' => 'Email and password are required'
    ]);
}

$conn->close();
?>
