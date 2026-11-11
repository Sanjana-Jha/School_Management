<?php

namespace Tests\Feature;

use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    /**
     * Test that the login page can be rendered.
     *
     * @return void
     */
    public function testLoginPageRender()
    {
        $response = $this->get('/login');

        $response->assertStatus(200);
        $response->assertSee('Login');
        $response->assertSee('password');
    }

    /**
     * Test that invalid login credentials fail validation or redirect back.
     *
     * @return void
     */
    public function testInvalidLoginAttempt()
    {
        $response = $this->post('/login', [
            'identity' => 'nonexistent_user',
            'password' => 'wrong_password',
        ]);

        $response->assertStatus(302);
    }
}
