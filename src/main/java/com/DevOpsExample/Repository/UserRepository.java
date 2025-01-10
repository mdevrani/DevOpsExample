package com.DevOpsExample.Repository;

import com.DevOpsExample.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
