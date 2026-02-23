<?php

require_once __DIR__ . '/../../core/Model.php';

class Permission extends Model
{
    public function getPermissionsByRole($role_id)
    {
        $stmt = $this->db->prepare("
            SELECT p.name 
            FROM permissions p
            JOIN role_permissions rp ON p.id = rp.permission_id
            WHERE rp.role_id = ?
        ");

        $stmt->execute([$role_id]);

        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }

    public function getPermissionDetailsByNames($permissionNames)
    {
        if (empty($permissionNames)) return [];

        $placeholders = implode(',', array_fill(0, count($permissionNames), '?'));

        $stmt = $this->db->prepare("
            SELECT name, module 
            FROM permissions
            WHERE name IN ($placeholders)
        ");

        $stmt->execute($permissionNames);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}