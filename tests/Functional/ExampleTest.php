<?php

namespace Tests\Functional;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * Test unauthenticated access to root redirects to login.
     *
     * @return void
     */
    public function testRootRedirectsToLogin()
    {
        $response = $this->get('/');
        $response->assertStatus(302);
        $response->assertRedirect('/login');
    }

    /**
     * Test unauthenticated access to dashboard redirects to login.
     *
     * @return void
     */
    public function testDashboardRequiresAuth()
    {
        $response = $this->get('/dashboard');
        $response->assertStatus(302);
        $response->assertRedirect('/login');
    }
}
